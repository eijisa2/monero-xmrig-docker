# Monero XMR Mining with Docker (CPU / RandomX)

Production-grade Monero (XMR) CPU mining using Docker.
Optimized with MSR registers and HugePages for maximum RandomX performance.

## Features
- CPU-only (RandomX)
- Dockerized XMRig (built from source)
- MSR register tuning (Intel)
- HugePages enabled
- Pool mining (SupportXMR tested)
- Reboot-safe production setup

## Requirements
- Linux host
- Docker
- Root / sudo access
- CPU with AES-NI (Intel / AMD)

## Quick Start (TL;DR)
```bash
sudo modprobe msr
sudo sysctl -w vm.nr_hugepages=128

docker run -d \
  --name xmrig \
  --privileged \
  --restart unless-stopped \
  xmrig-prod
