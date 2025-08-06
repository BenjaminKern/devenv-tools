#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 <install-dir>"
  exit 1
fi

download_with_retry() {
  local url="$1"
  local output="$2"
  local retries=3
  
  for ((i=1; i<=retries; i++)); do
    if curl -fsSL --connect-timeout 10 --max-time 300 "$url" -o "$output"; then
      return 0
    fi
    echo "Download failed (attempt $i/$retries): $url" >&2
    [[ $i -lt $retries ]] && sleep 2
  done
  return 1
}

extract_with_retry() {
  local url="$1"
  local extract_cmd="$2"
  local dest="$3"
  local retries=3
  
  for ((i=1; i<=retries; i++)); do
    if curl -fsSL --connect-timeout 10 --max-time 300 "$url" | $extract_cmd -C "$dest"; then
      return 0
    fi
    echo "Download/extract failed (attempt $i/$retries): $url" >&2
    [[ $i -lt $retries ]] && sleep 2
  done
  return 1
}

if [[ "$(uname)" == "Darwin" ]]; then
  DESTDIR="$(realpath "$1")"
else
  DESTDIR="$(readlink -e "$1")"
fi

mkdir -p "$DESTDIR"/{bin,config,zsh-autosuggestions,llama.cpp,share/nvim/runtime/{lua,snippets}}

echo "Downloading tools in parallel..."

pids=()

if [[ "$(uname)" == "Darwin" ]]; then
  extract_with_retry "https://github.com/BenjaminKern/devenv-tools/releases/download/latest/devenv-tools-aarch64-macos.tar.xz" "tar xfJ - --strip=1" "$DESTDIR" &
  pids+=($!)
  
  extract_with_retry "https://github.com/lima-vm/lima/releases/download/v1.2.1/lima-1.2.1-Darwin-arm64.tar.gz" "tar xfz - --strip=1" "$DESTDIR" &
  pids+=($!)
  
  extract_with_retry "https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.darwin.aarch64.tar.xz" "tar xfJ - --strip=1" "$DESTDIR/bin" &
  pids+=($!)
  
  extract_with_retry "https://github.com/ggml-org/llama.cpp/releases/download/b6075/llama-b6075-bin-macos-arm64.zip" "tar xfz - --strip=1" "$DESTDIR/llama.cpp" &
  pids+=($!)
else
  extract_with_retry "https://github.com/BenjaminKern/devenv-tools/releases/download/latest/devenv-tools-x86_64-linux.tar.xz" "tar xfJ - --strip=1" "$DESTDIR" &
  pids+=($!)
  
  extract_with_retry "https://github.com/lima-vm/lima/releases/download/v1.2.1/lima-1.2.1-Linux-x86_64.tar.gz" "tar xfz - --strip=1" "$DESTDIR" &
  pids+=($!)
  
  extract_with_retry "https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.linux.x86_64.tar.xz" "tar xfJ - --strip=1" "$DESTDIR/bin" &
  pids+=($!)
  
  download_with_retry "https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64" "$DESTDIR/bin/hadolint" &
  pids+=($!)
fi

echo "Downloading config files in parallel..."

download_with_retry "https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua" "$DESTDIR/share/nvim/runtime/lua/devenv_config.lua" &
pids+=($!)

download_with_retry "https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/all.json" "$DESTDIR/share/nvim/runtime/snippets/all.json" &
pids+=($!)

download_with_retry "https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.json" "$DESTDIR/share/nvim/runtime/snippets/cpp.json" &
pids+=($!)

download_with_retry "https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore" "$DESTDIR/share/nvim/.fd-ignore" &
pids+=($!)

download_with_retry "https://raw.githubusercontent.com/BenjaminKern/dotfiles/refs/heads/main/.config/xyz.omp.json" "$DESTDIR/config/xyz.omp.json" &
pids+=($!)

download_with_retry "https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.bash" "$DESTDIR/devenv_tools.bash" &
pids+=($!)

download_with_retry "https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.zsh" "$DESTDIR/devenv_tools.zsh" &
pids+=($!)

download_with_retry "https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/github_copilot_auth" "$DESTDIR/bin/github_copilot_auth" &
pids+=($!)

extract_with_retry "https://github.com/zsh-users/zsh-autosuggestions/archive/master.tar.gz" "tar xfz - --strip-components=1" "$DESTDIR/zsh-autosuggestions" &
pids+=($!)

failed=0
for pid in "${pids[@]}"; do
  if ! wait "$pid"; then
    failed=1
  fi
done

if [[ $failed -eq 1 ]]; then
  echo "Some downloads failed. Please check the errors above." >&2
  exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
  chmod u+x "$DESTDIR"/llama.cpp/bin/llama-* 2>/dev/null || true
else
  chmod u+x "$DESTDIR"/bin/hadolint 2>/dev/null || true
fi

chmod u+x "$DESTDIR"/bin/github_copilot_auth 2>/dev/null || true

echo "Add the following line to ~/.zshrc"
echo "source $DESTDIR/devenv_tools.zsh"
echo "Add the following line to ~/.bashrc"
echo "source $DESTDIR/devenv_tools.bash"
echo "Add the following line to ~/.config/nvim/init.lua"
echo "require('devenv_config')"
