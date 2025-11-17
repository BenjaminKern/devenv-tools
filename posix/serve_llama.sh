#!/usr/bin/env bash

llama-server -hf unsloth/Qwen3-Coder-30B-A3B-Instruct-1M-GGUF:Q4_K_M --alias "Qwen3-Coder" --ctx-size 131072 --jinja -ngl 99 --threads -1 --temp 0.7 --min-p 0.0 --top-p 0.80 --top-k 20 --repeat-penalty 1.05
