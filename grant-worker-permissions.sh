#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
chmod 750 -- install.sh setup-worker.sh grant-worker-permissions.sh start-worker.sh stop-worker.sh
echo "Права на запуск выданы. Старт: ./start-worker.sh. Остановка: ./stop-worker.sh."
