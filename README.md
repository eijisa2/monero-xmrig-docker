```markdown
# Monero (XMR) CPU Mining with Docker (XMRig)

This document describes a real-world, production-tested Monero CPU mining setup using Docker and XMRig. All steps below were executed manually and verified with live pool statistics.

---

## 1. Host Requirements

- **Linux host** (Ubuntu/Debian recommended)
- **Docker** installed and running
- **Root / sudo** access
- **Intel/AMD CPU** with AES-NI support
- System capable of **HugePages**
- Kernel **MSR** support

---

## 2. Enable MSR on Host (Required)

XMRig requires access to CPU MSR registers for optimal RandomX performance. Run these commands on your host machine:

```bash
sudo modprobe msr

```

**Verify:**

```bash
ls /dev/cpu/*/msr

```

*(Optional – Make it persistent after reboot)*

```bash
echo msr | sudo tee /etc/modules-load.d/msr.conf

```

---

## 3. Start a Clean Ubuntu Container

All build steps are performed inside a temporary container to keep your host clean.

```bash
docker run -it --name monero-dev ubuntu:24.04 bash

```

---

## 4. Install Build Dependencies (Inside Container)

Run the following inside the container:

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
git clone [https://github.com/xmrig/xmrig.git](https://github.com/xmrig/xmrig.git)
cd xmrig
mkdir build && cd build
cmake ..
make -j$(nproc)

```

**Verify the build:**

```bash
./xmrig --version

```

---

## 6. Create config.json (Inside Container)

```bash
nano config.json

```

**Example configuration:**

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

**Expected output:**

* Pool connection established.
* Shares accepted.
* *Note: MSR might fail inside the temporary container; this is expected until the final privileged run.*

**Stop and Exit:**
Press `Ctrl+C` then type `exit`.

---

## 8. Commit Container to Production Image (Host)

On your host terminal, save your progress into a clean production image:

```bash
docker commit \
  --change='WORKDIR /opt/xmrig/build' \
  --change='ENTRYPOINT ["./xmrig","-c","config.json"]' \
  monero-dev xmrig-prod

```

---

## 9. Run Production Miner (Host)

Launch the miner in the background with full hardware access:

```bash
docker run -d \
  --name xmrig \
  --privileged \
  --restart unless-stopped \
  xmrig-prod

```

---

## 10. Verify Runtime Status

Check if everything is running optimally:

```bash
docker logs -f xmrig

```

**Look for these critical success lines:**

* `msr register values for "intel" preset have been set successfully`
* `huge pages 100% 1168/1168`
* `cpu READY threads ...`

---

## 11. Pool Verification

1. Go to [supportxmr.com](https://supportxmr.com).
2. Paste your **Wallet Address** in the lookup field.
3. Verify that your worker is visible and the hashrate is updating.

---

## Notes

* This setup uses CPU-only **RandomX** algorithm.
* GPU / CUDA is intentionally excluded for this specific setup.
* Mining profitability depends heavily on your hardware efficiency and electricity costs.
* This project is intended for learning, experimentation, and long-term accumulation.

```
