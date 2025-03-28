#!/bin/bash

# Usage: PATH=/path/to/iree/build/tools:$PATH ./benchmark-unet.sh N

set -euo pipefail

if (( $# != 1 && $# != 2 )); then
  echo "usage: $0 <hip-device-id> [<irpa-path>]"
  exit 1
fi

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
readonly WORKING_DIR="${WORKING_DIR:-${SCRIPT_DIR}/tmp}"
readonly PREFIX="${PREFIX:-base}"
readonly IREE_BENCHMARK="$(which iree-benchmark-module)"
readonly HIP_DEVICE="$1"
readonly INPUT_PATH="${INPUT_PATH:-${SCRIPT_DIR}/inputs/8b_fp8/args_bs4_128}"
readonly USE_TRACY="${USE_TRACY:-0}"
readonly IREE_TRACY_CAPTURE="$(which iree-tracy-capture)"

readonly -a INPUTS=(
  "--input=4x128xi64=@${INPUT_PATH}/prefill_token_ids.bin"
  "--input=4xi64=@${INPUT_PATH}/prefill_seq_lens.bin"
  "--input=4x4xi64=@${INPUT_PATH}/prefill_seq_block_ids.bin"
  "--input=261x2097152xf8E4M3FNUZ=@${INPUT_PATH}/prefill_cache_state.bin"
)

# IRPA file:
# Size: 9081761792
# md5sum: da94d6e49c55322335374ac3e8585e32
readonly IRPA="${2:-/data/shark/8b_fp8.irpa}"

echo "Using IRPA file:"
stat -c "%y %s %n" "${IRPA}"
# md5sum "${IRPA}"

set -x

run_benchmark() {
  "$IREE_BENCHMARK" \
    --device="hip://${HIP_DEVICE}" \
    --device_allocator=caching \
    --hip_use_streams=true \
    --module="${WORKING_DIR}/${PREFIX}.8b_fp8.vmfb" \
    --parameters=model="${IRPA}" \
    --function=prefill_bs4 \
    "${INPUTS[@]}" \
    --benchmark_repetitions=3
}

if (( "${USE_TRACY}" == "1")); then
  IREE_PY_RUNTIME=tracy TRACY_NO_EXIT=1 run_benchmark &
  "${IREE_TRACY_CAPTURE}" -f -o "${WORKING_DIR}/${PREFIX}.8b_fp8.tracy"
else
  run_benchmark
fi
