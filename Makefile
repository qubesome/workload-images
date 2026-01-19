REGISTRY ?= workload-images
TAG ?= latest

BUILDER ?= docker buildx

WORKLOADS=$(shell find workloads -mindepth 2 -maxdepth 2 -type f -name 'Dockerfile' | sort -u | cut -f 2 -d'/')
TOOLS=$(shell find tools -mindepth 2 -maxdepth 2 -type f -name 'Dockerfile' | sort -u | cut -f 2 -d'/')

MACHINE = qubesome

# ACTION can only be --load when TARGET_PLATFORM is the current platform:
#   TARGET_PLATFORMS=linux/amd64 ACTION=--load make build-workload-xorg
ACTION ?= --load
TARGET_PLATFORMS ?= $(shell docker info --format '{{.ClientInfo.Os}}/{{.ClientInfo.Arch}}')
SUPPORTED_PLATFORMS = linux/amd64,linux/arm64

# Workloads that do not support arm64:
AMD64_ONLY = chrome slack obsidian
$(foreach w,$(AMD64_ONLY),$(eval build-workload-$(w): TARGET_PLATFORMS = linux/amd64))

build: build-workload-base
	$(MAKE) $(addprefix build-workload-, $(WORKLOADS))
	$(MAKE) $(addprefix build-tool-, $(TOOLS))

buildx-machine:
	$(BUILDER) use $(MACHINE) >/dev/null 2>&1  || \
		$(BUILDER) create --name=$(MACHINE) --driver-opt network=host --platform=$(SUPPORTED_PLATFORMS)

build-workload-%: buildx-machine
	cd workloads/$(subst :,/,$*); \
		$(BUILDER) build --builder $(MACHINE) --platform="$(TARGET_PLATFORMS)" \
			--build-arg=REGISTRY=$(REGISTRY) --build-arg=TAG=$(TAG) \
			$(ACTION) -t $(REGISTRY)/$(subst :,/,$*):$(TAG) -f Dockerfile .

build-tool-%: buildx-machine
	cd tools/$(subst :,/,$*); \
		$(BUILDER) build --builder $(MACHINE) --platform="$(TARGET_PLATFORMS)" \
			--build-arg=REGISTRY=$(REGISTRY) --build-arg=TAG=$(TAG) \
			$(ACTION) -t $(REGISTRY)/$(subst :,/,$*):$(TAG) -f Dockerfile .

push:
	$(MAKE) $(addprefix push-workload-, $(WORKLOADS))
	$(MAKE) $(addprefix push-tool-, $(TOOLS))

push-workload-%:
	ACTION=--push \
	TARGET_PLATFORMS=$(SUPPORTED_PLATFORMS) \
		$(MAKE) build-workload-$(subst :,/,$*)

ifneq ($(TAG),latest)
	cosign sign --yes "$(REGISTRY)/$(subst :,/,$*):$(TAG)"
endif

push-tool-%: build-tool-%
	cd tools/$(subst :,/,$*); \
		$(BUILDER) push $(REGISTRY)/$(subst :,/,$*):$(TAG)
ifneq ($(TAG),latest)
	cosign sign --yes "$(REGISTRY)/$(subst :,/,$*):$(TAG)"
endif
