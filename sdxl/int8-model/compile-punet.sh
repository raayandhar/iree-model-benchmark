#!/bin/bash

# Usage: PATH=/path/to/iree/build/tools:$PATH ./compile-unet.sh <target-chip> [extra flags]

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

readonly IREE_COMPILE="$(which iree-compile)"
readonly CHIP="$1"
WORKING_DIR="${WORKING_DIR:-${SCRIPT_DIR}}"
shift

set -x


"${SCRIPT_DIR}/compile-punet-base.sh" "$IREE_COMPILE" "$CHIP" \
  "${SCRIPT_DIR}/base_ir/punet_07_18.mlir" \
  --iree-hal-dump-executable-configurations-to="${WORKING_DIR}/tmp/configurations" \
  --iree-hal-dump-executable-intermediates-to="${WORKING_DIR}/tmp/intermediates" \
  --iree-hal-dump-executable-sources-to="${WORKING_DIR}/tmp/sources" \
  --iree-hal-dump-executable-binaries-to="${WORKING_DIR}/tmp/binaries" \
  --iree-hal-dump-executable-benchmarks-to="${WORKING_DIR}/tmp/benchmarks" \
  --iree-scheduling-dump-statistics-file="${WORKING_DIR}/tmp/punet_scheduling_stats.txt" \
  --iree-scheduling-dump-statistics-format=csv \
  -o "${WORKING_DIR}/tmp/punet.vmfb" \
  "$@"
