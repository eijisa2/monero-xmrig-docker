# Monero XMR Mining with Docker (CPU / RandomX)

This repository documents a real-world Monero (XMR) CPU mining setup
using Docker and XMRig.

The focus is simplicity first, optimization later.

---

## Scope
- CPU-only mining (RandomX)
- Docker-based workflow
- Built and tested on a real Linux host
- No GPU / CUDA focus

---

## Requirements
- Linux host
- Docker installed
- CPU with AES-NI support
- Internet connection

---

## Usage (minimal)
```bash
docker compose build
docker compose up -d
docker logs -f xmrig
