---

````md
# Monero (XMR) CPU Mining with Docker (XMRig)

This repository documents a **real-world, production-tested Monero (XMR) CPU mining setup**
using **Docker** and **XMRig**.

All commands were executed manually and verified against live pool statistics.
The setup is designed for **stability, performance, and reproducibility**.

---

## Overview

- CPU-only Monero mining (RandomX)
- Docker-based build and runtime
- XMRig compiled from source
- MSR and HugePages enabled
- Tested with live mining pools

---

## 1. Host Requirements

- Linux host
- Docker installed
- Root / sudo access
- Intel CPU with **AES-NI**
- System capable of **HugePages**
- Kernel **MSR** support

---

## 2. Enable MSR on Host (Required)

XMRig requires access to CPU MSR registers for optimal RandomX performance.

Load the MSR module:

```bash
sudo modprobe msr
````

Verify:

```bash
ls /dev/cpu/*/msr
```

(Optional – make persistent across reboots):

```bash
echo msr | sudo tee /etc/modules-load.d/msr.conf
```

---

## 3. Start a Clean Ubuntu Container

All build steps are performed **inside the container**.

```bash
docker run -it --name monero-dev ubuntu:24.04 bash
```

---

## 4. Install Build Dependencies (Inside Container)

```bash
apt update
apt install -y \
  git build-essential cmake \
  libuv1-dev libssl-dev libhwloc-dev \
  ca-certificates nano
```

---

## 5. Build XMRig from Source (Inside Container)

```bash
cd /opt
git clone https://github.com/xmrig/xmrig.git
cd xmrig
mkdir build && cd build
cmake ..
make -j$(nproc)
```

Verify build:

```bash
./xmrig --version
```

---

## 6. Create `config.json` (Inside Container)

```bash
cd /opt/xmrig/build
nano config.json
```

Example configuration:

```json
{
  "donate-level": 1,
  "cpu": {
    "enabled": true,
    "huge-pages": true
  },
  "msr": {
    "enabled": true
  },
  "pools": [
    {
      "url": "pool.supportxmr.com:3333",
      "user": "YOUR_MONERO_WALLET_ADDRESS",
      "pass": "docker-xmrig",
      "keepalive": true,
      "tls": false
    }
  ]
}
```
---

## 7. Test Mining Inside Container

```bash
./xmrig -c config.json
```

Expected output:

```text
Pool connection established
Shares accepted
```

> MSR warnings may appear here — this is expected inside a non-privileged container.

Stop mining:

```text
Ctrl + C
```

Exit the container:

```bash
exit
```

---

## 8. Commit Container to Production Image (Host)

```bash
docker commit \
  --change='WORKDIR /opt/xmrig/build' \
  --change='ENTRYPOINT ["./xmrig","-c","config.json"]' \
  monero-dev xmrig-prod
```

---

## 9. Run Production Miner (Host)

```bash
docker run -d \
  --name xmrig \
  --privileged \
  --restart unless-stopped \
  xmrig-prod
```

---

## 10. Verify Runtime Status

```bash
docker logs -f xmrig
```

Expected critical lines:

```text
msr      register values for "intel" preset have been set successfully
huge pages 100% 1168/1168
cpu READY threads ...
```

This confirms:

* MSR active
* HugePages active
* Optimal
