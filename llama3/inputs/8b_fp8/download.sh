#!/bin/bash

# Usage: ./download.sh [128]

set -euo pipefail

if (( $# != 1 )); then
    echo "usage : $0 [128]"
    exit 1
fi

set -x

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
cd "${SCRIPT_DIR}"

readonly SEQ_LEN="$1"

readonly URL_PREFIX="https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/args_bs4_fp8_${SEQ_LEN}"

echo "Get bs4 ${SEQ_LEN} seq len fp8 args"

mkdir -p "args_bs4_${SEQ_LEN}"
cd "args_bs4_${SEQ_LEN}"

wget -q --show-progress "${URL_PREFIX}/prefill_token_ids.bin" &
wget -q --show-progress "${URL_PREFIX}/prefill_seq_lens.bin" &
wget -q --show-progress "${URL_PREFIX}/prefill_seq_block_ids.bin" &
wget -q --show-progress "${URL_PREFIX}/prefill_cache_state.bin"

echo Done
