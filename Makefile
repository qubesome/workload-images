REGISTRY ?= workload-images
TAG ?= latest

BUILDER ?= docker
RUNNER ?= docker

WORKLOADS=$(shell find workloads -mindepth 2 -maxdepth 2 -type f -name 'Dockerfile' | sort -u | cut -f 2 -d'/')
TOOLS=$(shell find tools -mindepth 2 -maxdepth 2 -type f -name 'Dockerfile' | sort -u | cut -f 2 -d'/')

build:
	$(MAKE) $(addprefix build-workload-, $(WORKLOADS))
	$(MAKE) $(addprefix build-tool-, $(TOOLS))

build-workload-%:
	cd workloads/$(subst :,/,$*); \
		$(BUILDER) build --build-arg=REGISTRY=$(REGISTRY) --build-arg=TAG=$(TAG) \
			-t $(REGISTRY)/$(subst :,/,$*):$(TAG) -f Dockerfile .

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
