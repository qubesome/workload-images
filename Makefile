REGISTRY ?= workload-images
TAG ?= latest

BUILDER ?= docker
RUNNER ?= docker

ALL_WORKLOADS=$(shell find workloads -mindepth 2 -maxdepth 2 -type f -name 'Dockerfile' | sort -u | cut -f 2 -d'/')
TOOLS=$(shell find tools -mindepth 2 -maxdepth 2 -type f -name 'Dockerfile' | sort -u | cut -f 2 -d'/')

# Workloads holding a .local marker are too large for the CI and release
# cycle. They are never built nor published there, only by build-local.
LOCAL_WORKLOADS=$(shell find workloads -mindepth 2 -maxdepth 2 -type f -name '.local' | sort -u | cut -f 2 -d'/')
WORKLOADS=$(filter-out $(LOCAL_WORKLOADS),$(ALL_WORKLOADS))

build:
	$(MAKE) $(addprefix build-workload-, $(WORKLOADS))
	$(MAKE) $(addprefix build-tool-, $(TOOLS))

# Builds the .local workloads, along with the images they are built on.
build-local:
	@hack/affected.sh --local | while read -r target; do \
		$(MAKE) "build-$$target" || exit 1; \
	done

# Builds the images affected by the changes since BASE_REF, in dependency
# order. Without BASE_REF every image is built.
build-affected:
	@targets="$$(hack/affected.sh "$(BASE_REF)")"; \
	if [ -z "$$targets" ]; then \
		echo "no affected images"; \
	fi; \
	echo "$$targets" | while read -r target; do \
		[ -n "$$target" ] || continue; \
		$(MAKE) "build-$$target" || exit 1; \
	done

build-workload-%:
	cd workloads/$(subst :,/,$*); \
		$(BUILDER) build --build-arg=REGISTRY=$(REGISTRY) --build-arg=TAG=$(TAG) \
			--load -t $(REGISTRY)/$(subst :,/,$*):$(TAG) -f Dockerfile .

build-tool-%:
	cd tools/$(subst :,/,$*); \
		$(BUILDER) build --build-arg=REGISTRY=$(REGISTRY) --build-arg=TAG=$(TAG) \
			-t $(REGISTRY)/$(subst :,/,$*):$(TAG) -f Dockerfile .

push:
	$(MAKE) $(addprefix push-workload-, $(WORKLOADS))
	$(MAKE) $(addprefix push-tool-, $(TOOLS))

push-workload-%: build-workload-%
	cd workloads/$(subst :,/,$*); \
		$(BUILDER) push $(REGISTRY)/$(subst :,/,$*):$(TAG)
ifneq ($(TAG),latest)
	cosign sign --yes "$(REGISTRY)/$(subst :,/,$*):$(TAG)"
endif

push-tool-%: build-tool-%
	cd tools/$(subst :,/,$*); \
		$(BUILDER) push $(REGISTRY)/$(subst :,/,$*):$(TAG)
ifneq ($(TAG),latest)
	cosign sign --yes "$(REGISTRY)/$(subst :,/,$*):$(TAG)"
endif
