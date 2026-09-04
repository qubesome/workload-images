ARG TAG=latest
ARG REGISTRY=ghcr.io/qubesome

# The ollama release tarball is zstd compressed and cli-llm has no package
# manager left to install zstd into, so unpack it where zypper still exists.
FROM ${REGISTRY}/base:${TAG} AS ollama

# renovate: datasource=github-releases depName=ollama/ollama
ENV OLLAMA_VERSION=v0.33.3
ENV OLLAMA_URL="https://github.com/ollama/ollama/releases/download/${OLLAMA_VERSION}"

WORKDIR /tmp
RUN zypper -n install curl tar zstd && \
    curl -fsSLO "${OLLAMA_URL}/sha256sum.txt" && \
    curl -fsSLO "${OLLAMA_URL}/ollama-linux-amd64.tar.zst" && \
    grep " \./ollama-linux-amd64.tar.zst\$" sha256sum.txt | sha256sum -c && \
    mkdir -p /opt/ollama && \
    tar --zstd -C /opt/ollama -xf ollama-linux-amd64.tar.zst

FROM ${REGISTRY}/cli-llm:${TAG}

USER root

# ollama resolves its backends relative to the binary, as ../lib/ollama.
COPY --from=ollama /opt/ollama/bin/ /usr/local/bin/
COPY --from=ollama /opt/ollama/lib/ /usr/local/lib/

# Inference offloads to the GPU passed in as /dev/dri.
RUN usermod -aG video,render coder && \
    ollama --version

USER coder

# renovate: datasource=npm depName=@qwen-code/qwen-code
ENV QWEN_VERSION=0.23.0
RUN . "$HOME/.nvm/nvm.sh" && \
    npm install -g "@qwen-code/qwen-code@${QWEN_VERSION}" && \
    qwen --version

ENV OLLAMA_MODEL="qwen3:8b"

# Integrated GPUs are skipped during discovery unless this is set.
ENV OLLAMA_IGPU_ENABLE=1

# Bake the weights into the image so the workload needs no network at runtime.
# Keep /home/coder/.ollama off VOLUME, a bind mount over it hides them.
RUN set -e; \
    ollama serve > /tmp/ollama.log 2>&1 & \
    for i in $(seq 30); do ollama list > /dev/null 2>&1 && break; sleep 1; done; \
    ollama pull "${OLLAMA_MODEL}"; \
    pkill -x ollama; \
    rm -f /tmp/ollama.log

# qwen speaks to the local ollama through its OpenAI compatible API.
ENV OPENAI_BASE_URL="http://127.0.0.1:11434/v1" \
    OPENAI_API_KEY="ollama" \
    OPENAI_MODEL="${OLLAMA_MODEL}"

COPY --chown=0:0 --chmod=755 start /usr/local/bin/

WORKDIR /home/coder

LABEL org.opencontainers.image.source="https://github.com/qubesome/workload-images" \
      org.opencontainers.image.ref.name="cli-qwen" \
      org.opencontainers.image.title="qubesome cli-qwen workload" \
      org.opencontainers.image.description="cli-llm with a self contained Qwen3 8B for qubesome."
