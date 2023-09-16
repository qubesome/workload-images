REGISTRY :=
TAG := latest

BUILDER := docker
RUNNER := docker

PROFILE ?= personal

UNTRUSTED := --pids-limit=30

NO_INTERNET := --network none

# --cpus 2 --memory 2048M
COMMON := --rm -d \
		  	-v /etc/localtime:/etc/localtime:ro

COMMON_IT := --rm -it \
		  	-v /etc/localtime:/etc/localtime:ro

MAP_HOST_FONTS := -v /usr/share/fonts:/usr/share/fonts \
	-v /usr/local/share/fonts:/usr/local/share/fonts

# Test with https://demo.yubico.com/webauthn-technical/registration
YUBIKEY := --device /dev/hidraw1 \
			--device /dev/hidraw2 \
			-v /dev:/dev

CAMERA := --device /dev/hidraw3 \
			--device /dev/hidraw4 \
			--device /dev/hidraw5 \
			--device=/dev/video0 \
			--group-add video

RUNNER_GUI_ARGS := --security-opt seccomp=unconfined \
	--device /dev/dri:/dev/dri \
	-v /dev/shm:/dev/shm \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
	-v /run/user/1000/bus:/run/user/1000/bus \
    -v /var/lib/dbus:/var/lib/dbus \
	-v /run/user/1000/dbus-1:/run/user/1000/dbus-1 \
	-v /etc/machine-id:/etc/machine-id:ro \
	-e DISPLAY \
	-e DBUS_SESSION_BUS_ADDRESS \
	-e XDG_RUNTIME_DIR \
	-e XDG_SESSION_ID

SOUND := -v /run/user/1000/pipewire-0:/run/user/1000/pipewire-0 \
			--device /dev/snd \
			--group-add audio 

IMAGES=$(shell find . -mindepth 3 -maxdepth 3 -type f -name 'Dockerfile' | sort -u | cut -f 3 -d'/')

build:
	$(MAKE) $(addprefix build-, $(IMAGES))

build-%:
	cd workloads/$(subst :,/,$*); \
		$(BUILDER) build -t $(REGISTRY)$(subst :,/,$*):$(TAG) -f Dockerfile .

run-%:
	cd workloads/$(subst :,/,$*); PROFILE=$(PROFILE) REGISTRY=$(REGISTRY) TAG=$(TAG) ./qubesome-*

.PHONY: chrome
chrome:
	$(RUNNER) run $(COMMON) $(RUNNER_GUI_ARGS) $(MAP_HOST_FONTS) $(SOUND) $(YUBIKEY) $(CAMERA) --name chrome \
    	-v "${HOME}/Downloads:/home/chrome/Downloads" \
		-v ~/.config/google-chrome:/home/chrome/.config/google-chrome \
		$(REGISTRY)google-chrome:$(TAG) \
		google-chrome

.PHONY: vscode
vscode:
	$(RUNNER) run $(NO_INTERNET) $(COMMON) $(RUNNER_GUI_ARGS) $(YUBIKEY) --name vscode \
		-v ~/git:/home/coder/git \
		-v ~/go:/home/coder/go \
		-v ~/.config/Code:/home/coder/.config/Code \
		-v /run/user/1000:/run/user/1000 \
		$(REGISTRY)vscode:$(TAG) \
		code --disable-gpu --verbose

.PHONY: cli
cli:
	$(RUNNER) run --read-only $(COMMON_IT) $(YUBIKEY) --name vscode \
		-v ~/git:/home/coder/git \
		-v ~/go:/home/coder/go \
		-v ~/.gitconfig:/home/coder/.gitconfig \
		-v ~/.gitconfig-work:/home/coder/.gitconfig-work \
		-v ~/.gitignore:/home/coder/.gitignore \
		-v ~/.oh-my-zsh:/home/coder/.oh-my-zsh \
		-v ~/.zshrc:/home/coder/.zshrc \
		-v ~/.ssh/known_hosts:/home/coder/.ssh/known_hosts \
		$(REGISTRY)git:$(TAG) \
		zsh

.PHONY: slack
slack:
	$(RUNNER) run $(COMMON) $(RUNNER_GUI_ARGS) $(MAP_HOST_FONTS) --name slack \
		-v ~/snap/slack/current/.config:/home/slacker/.config \
		-v ~/snap/slack/current/.themes:/home/slacker/.themes \
		-v ~/snap/slack/current/.share:/home/slacker/.share \
		$(REGISTRY)slack:$(TAG) \
		slack
