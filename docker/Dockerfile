FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG XMRIG_GIT_REF=v6.25.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    build-essential cmake \
    libuv1-dev libssl-dev libhwloc-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/xmrig/xmrig.git && \
    cd xmrig && git checkout "${XMRIG_GIT_REF}" && \
    mkdir build && cd build && \
    cmake .. && make -j"$(nproc)"

# Minimal runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    libuv1t64 libssl3 libhwloc15 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/xmrig/build
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
