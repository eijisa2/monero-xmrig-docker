#!/usr/bin/env bash
set -euo pipefail

# Required:
: "${POOL_URL:?Set POOL_URL (e.g. pool.supportxmr.com:3333)}"
: "${WALLET_ADDRESS:?Set WALLET_ADDRESS (your XMR address)}"

# Optional:
WORKER_NAME="${WORKER_NAME:-docker-xmrig}"
POOL_PASS="${POOL_PASS:-x}"
TLS="${TLS:-false}"
DONATE_LEVEL="${DONATE_LEVEL:-1}"
EXTRA_ARGS="${EXTRA_ARGS:-}"

CONFIG_PATH="${CONFIG_PATH:-/opt/xmrig/build/config.json}"

cat > "${CONFIG_PATH}" <<EOF
{
  "autosave": true,
  "donate-level": ${DONATE_LEVEL},
  "cpu": {
    "enabled": true,
    "huge-pages": true
  },
  "msr": {
    "enabled": true
  },
  "pools": [
    {
      "url": "${POOL_URL}",
      "user": "${WALLET_ADDRESS}",
      "pass": "${POOL_PASS}",
      "rig-id": "${WORKER_NAME}",
      "keepalive": true,
      "tls": ${TLS}
    }
  ]
}
EOF

exec ./xmrig -c "${CONFIG_PATH}" ${EXTRA_ARGS}
