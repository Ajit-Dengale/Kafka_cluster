#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Choose an action:"
echo "1) Start cluster"
echo "2) Stop cluster"
read -r -p "Enter 1 or 2: " choice

case "$choice" in
  1)
    ./scripts/start-everything.sh
    ;;
  2)
    ./scripts/stop-everything.sh
    ;;
  *)
    echo "Invalid choice. Please enter 1 or 2." >&2
    exit 1
    ;;
esac
