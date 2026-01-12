# Monero XMR Mining with Docker (CPU / RandomX)

This repository documents a real-world setup of Monero (XMR) CPU mining
using Docker and XMRig.

The goal is simplicity first, optimization later.

---

## What this repository is
- CPU-only Monero mining (RandomX)
- Docker-based setup
- Built and tested on a real server
- Focused on reproducibility, not hype

---

## What this repository is NOT
- Not a "get rich quick" mining guide
- Not GPU/CUDA focused
- Not beginner hand-holding magic

---

## Minimal Requirements
- Linux host
- Docker installed
- CPU with AES-NI support
- Internet connection

That's enough to start mining.

---

## Basic Usage

```bash
docker compose build
docker compose up -d
docker logs -f xmrig
