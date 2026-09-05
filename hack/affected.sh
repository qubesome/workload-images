#!/usr/bin/env bash

# Prints the images affected by a change, as make target suffixes and in the
# order they have to be built. A change to an image affects everything built
# on top of it, and building an image requires its own ancestors to be built
# first, as CI never publishes the tag they are pulled by.
#
# Images marked .local are built by hand and never in CI, so they are always
# left out. Without a base ref, or when a change reaches outside the image
# directories, every image is affected.
#
# With --local the selection is inverted: only the .local images, and the
# ancestors they need, are printed.

set -euo pipefail

cd "$(dirname "$0")/.."

mode="affected"
if [ "${1:-}" = "--local" ]; then
	mode="local"
	shift
fi

base_ref="${1:-}"

declare -A parents=()
declare -A raw_parents=()
declare -A by_name=()
declare -A local_only=()
all=()

for dockerfile in workloads/*/Dockerfile tools/*/Dockerfile; do
	dir="$(dirname "${dockerfile}")"
	kind="${dir%%/*}"
	name="${dir#*/}"
	target="${kind%s}-${name}"

	all+=("${target}")

	# Images are referenced by name alone, so a name may only be used once
	# across workloads and tools.
	if [ -n "${by_name[${name}]:-}" ]; then
		echo "image name ${name} is used by both ${by_name[${name}]} and ${target}" >&2
		exit 1
	fi
	by_name["${name}"]="${target}"

	if [ -f "${dir}/.local" ]; then
		local_only["${target}"]=1
	fi

	# Only images from this repository are tracked. Anything else is either
	# an upstream image or a stage local to the Dockerfile.
	raw_parents["${target}"]="$(sed -n 's|^FROM \${REGISTRY}/\([^:]*\):.*|\1|p' "${dockerfile}" | sort -u | tr '\n' ' ')"
done

# Parents are resolved once every image is known, as an image may be built on
# either a workload or a tool.
for target in "${all[@]}"; do
	resolved=""

	for name in ${raw_parents[${target}]}; do
		if [ -z "${by_name[${name}]:-}" ]; then
			echo "${target} is built on ${name}, which is not an image in this repository" >&2
			exit 1
		fi

		resolved+="${by_name[${name}]} "
	done

	parents["${target}"]="${resolved}"
done

declare -A affected=()

select_all() {
	for target in "${all[@]}"; do
		affected["${target}"]=1
	done
}

if [ "${mode}" = "local" ]; then
	for target in "${all[@]}"; do
		if [ -n "${local_only[${target}]:-}" ]; then
			affected["${target}"]=1
		fi
	done
elif [ -z "${base_ref}" ]; then
	select_all
else
	everything=0
	while read -r file; do
		[ -n "${file}" ] || continue

		case "${file}" in
		workloads/*/* | tools/*/*)
			kind="${file%%/*}"
			name="$(echo "${file}" | cut -d/ -f2)"
			affected["${kind%s}-${name}"]=1
			;;
		*)
			everything=1
			;;
		esac
	done < <(git diff --name-only "${base_ref}" HEAD)

	if [ "${everything}" -eq 1 ]; then
		select_all
	fi
fi

# Whatever is built on top of an affected image is affected too.
changed=1
while [ "${mode}" = "affected" ] && [ "${changed}" -eq 1 ]; do
	changed=0
	for target in "${all[@]}"; do
		[ -z "${affected[${target}]:-}" ] || continue

		for parent in ${parents[${target}]}; do
			if [ -n "${affected[${parent}]:-}" ]; then
				affected["${target}"]=1
				changed=1
			fi
		done
	done
done

# An affected image can only be built once its ancestors are.
changed=1
while [ "${changed}" -eq 1 ]; do
	changed=0
	for target in "${all[@]}"; do
		[ -n "${affected[${target}]:-}" ] || continue

		for parent in ${parents[${target}]}; do
			if [ -z "${affected[${parent}]:-}" ]; then
				affected["${parent}"]=1
				changed=1
			fi
		done
	done
done

declare -A built=()
remaining=1
while [ "${remaining}" -eq 1 ]; do
	remaining=0
	progress=0

	for target in "${all[@]}"; do
		[ -n "${affected[${target}]:-}" ] || continue
		[ -z "${built[${target}]:-}" ] || continue

		ready=1
		for parent in ${parents[${target}]}; do
			if [ -n "${affected[${parent}]:-}" ] && [ -z "${built[${parent}]:-}" ]; then
				ready=0
			fi
		done

		if [ "${ready}" -eq 0 ]; then
			remaining=1
			continue
		fi

		built["${target}"]=1
		progress=1

		if [ "${mode}" = "local" ] || [ -z "${local_only[${target}]:-}" ]; then
			echo "${target}"
		fi
	done

	if [ "${remaining}" -eq 1 ] && [ "${progress}" -eq 0 ]; then
		echo "cyclic image dependency detected" >&2
		exit 1
	fi
done
