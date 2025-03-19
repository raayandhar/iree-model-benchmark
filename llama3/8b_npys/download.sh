#!/bin/bash

set -xeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
cd "${SCRIPT_DIR}"

mkdir -p prefill_args_bs4_128_stride_32
cd prefill_args_bs4_128_stride_32
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/prefill_args_bs4_128_stride_32/cs_f16.npy
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/prefill_args_bs4_128_stride_32/seq_block_ids.npy
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/prefill_args_bs4_128_stride_32/seq_lens.npy
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/prefill_args_bs4_128_stride_32/tokens.npy

cd ..

mkdir -p decode_args_bs4_128_stride_32
cd decode_args_bs4_128_stride_32
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/decode_args_bs4_128_stride_32/cs_f16.npy
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/decode_args_bs4_128_stride_32/seq_block_ids.npy
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/decode_args_bs4_128_stride_32/start_positions.npy
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/decode_args_bs4_128_stride_32/seq_lens.npy
wget https://sharkpublic.blob.core.windows.net/sharkpublic/halo-models/llm-dev/llama3_8b/decode_args_bs4_128_stride_32/next_tokens.npy

echo Done
