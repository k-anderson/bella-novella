# The repo's bin/, lib/, mod/ are aarch64 (Raspberry Pi) FreeSWITCH 1.11.1.
# To run those exact binaries on an x86_64 Codespaces host we use an arm64
# Debian bookworm userland (matches Raspberry Pi OS bookworm) executed under
# QEMU emulation. The devcontainer's initializeCommand registers the QEMU
# binfmt handler so this image can build and run.
FROM --platform=linux/arm64 debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Runtime shared libraries the committed binaries link against. The repo ships
# only libfreeswitch.so; everything else comes from here. (Sofia-SIP is static
# inside mod_sofia.so, so no sofia package is needed.)
#
# Plus harness tooling: ip (iproute2), logger (bsdextrautils), flock
# (util-linux), gawk, sudo, procps, ss (iproute2); and baresip as a headless
# CLI softphone for full call simulation.
RUN apt-get update && apt-get install -y --no-install-recommends \
      libssl3 \
      libcurl4 \
      libedit2 \
      libsqlite3-0 \
      libspandsp2 \
      libspeex1 \
      libspeexdsp1 \
      libsndfile1 \
      libopus0 \
      libuuid1 \
      ca-certificates \
      sudo \
      iproute2 \
      procps \
      util-linux \
      bsdextrautils \
      gawk \
      less \
      vim-tiny \
      git \
      baresip \
      sip-tester \
    && rm -rf /var/lib/apt/lists/*

# Run the repo's FreeSWITCH binaries directly: bin/ on PATH, lib/ on the loader
# path. fs_cli then works with no wrapper and its built-in defaults
# (127.0.0.1:8021 / ClueCon).
ENV PATH=/usr/local/freeswitch/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/freeswitch/lib

WORKDIR /usr/local/freeswitch
