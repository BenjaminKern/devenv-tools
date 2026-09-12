#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

if [[ -z "${1:-}" ]] || [[ -z "${2:-}" ]]; then
  echo "Usage: $0 <install-dir> <target>"
  echo "Valid targets: aarch64-macos, aarch64-linux, x86_64-linux"
  exit 1
fi

LLAMA_VERSION="b10924"
SHELLCHECK_VERSION="v0.11.0"
HADOLINT_VERSION="v2.14.0"
ZMX_VERSION="0.8.1"
PI_AGENT_VERSION="v0.85.1"
BUN_VERSION="v1.4.2"

case "$2" in
  aarch64-macos)
    DEVENV_SUFFIX="aarch64-macos"
    SHELLCHECK_ARCH="darwin.aarch64"
    HADOLINT_SUFFIX="Darwin-arm64"
    LLAMA_SUFFIX="macos-arm64"
    ZMX_SUFFIX="macos-aarch64"
    PI_AGENT_SUFFIX="darwin-arm64"
    BUN_SUFFIX="darwin-aarch64"
    ;;
  aarch64-linux)
    DEVENV_SUFFIX="aarch64-linux"
    SHELLCHECK_ARCH="linux.aarch64"
    HADOLINT_SUFFIX="Linux-arm64"
    LLAMA_SUFFIX="ubuntu-arm64"
    ZMX_SUFFIX="linux-aarch64"
    PI_AGENT_SUFFIX="linux-arm64"
    BUN_SUFFIX="linux-aarch64"
    ;;
  x86_64-linux)
    DEVENV_SUFFIX="x86_64-linux"
    SHELLCHECK_ARCH="linux.x86_64"
    HADOLINT_SUFFIX="Linux-x86_64"
    LLAMA_SUFFIX="ubuntu-x64"
    ZMX_SUFFIX="linux-x86_64"
    PI_AGENT_SUFFIX="linux-x64"
    BUN_SUFFIX="linux-x64"
    ;;
  *)
    echo "Unknown target: $2"
    echo "Valid targets: aarch64-macos, aarch64-linux, x86_64-linux"
    exit 1
    ;;
esac

if [[ "$(uname)" == "Darwin" ]]; then
  DESTDIR="$(realpath "$1")"
else
  DESTDIR="$(readlink -e "$1")"
fi
NVIM_CONFIG_DIR="${DESTDIR}"

STEP=1
TOTAL=13

progress() {
  echo "[$STEP/$TOTAL] $1"
  STEP=$((STEP + 1))
}

progress "devenv-tools (${DEVENV_SUFFIX})"
curl -sL "https://github.com/BenjaminKern/devenv-tools/releases/download/latest/devenv-tools-${DEVENV_SUFFIX}.tar.xz" | tar xfJ - --strip=1 -C "$DESTDIR"

progress "shellcheck ${SHELLCHECK_VERSION}"
curl -sL "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.${SHELLCHECK_ARCH}.tar.xz" | tar xfJ - --strip=1 -C "$DESTDIR"/bin

progress "hadolint ${HADOLINT_VERSION}"
curl -Ls "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-${HADOLINT_SUFFIX}" -o "$DESTDIR"/bin/hadolint
chmod u+x "$DESTDIR"/bin/hadolint

progress "zmx ${ZMX_VERSION}"
curl -Ls "https://zmx.sh/a/zmx-${ZMX_VERSION}-${ZMX_SUFFIX}.tar.gz" | tar xfz - -C "$DESTDIR"/bin

progress "pi-agent ${PI_AGENT_VERSION}"
curl -sL "https://github.com/earendil-works/pi/releases/download/${PI_AGENT_VERSION}/pi-${PI_AGENT_SUFFIX}.tar.gz" | tar xfz - -C "$DESTDIR"

progress "llama.cpp ${LLAMA_VERSION}"
mkdir -p "$DESTDIR"/llama.cpp
curl -Ls "https://github.com/ggml-org/llama.cpp/releases/download/${LLAMA_VERSION}/llama-${LLAMA_VERSION}-bin-${LLAMA_SUFFIX}.tar.gz" | tar xfz - --strip=1 -C "$DESTDIR"/llama.cpp

progress "bun ${BUN_VERSION}"
curl -Ls "https://github.com/oven-sh/bun/releases/download/bun-${BUN_VERSION}/bun-${BUN_SUFFIX}.zip" | tar xfz - --strip=1 -C "$DESTDIR"/llama.cpp

mkdir -p "$DESTDIR"/{config,zsh-autosuggestions}
mkdir -p "$NVIM_CONFIG_DIR"/share/nvim/runtime/snippets

progress "nvim config"
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o "$NVIM_CONFIG_DIR"/share/nvim/runtime/lua/devenv_config.lua
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/all.json -o "$NVIM_CONFIG_DIR"/share/nvim/runtime/snippets/all.json
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.json -o "$NVIM_CONFIG_DIR"/share/nvim/runtime/snippets/cpp.json
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore -o "$DESTDIR"/share/nvim/.fd-ignore
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/refs/heads/main/.config/xyz.omp.json -o "$DESTDIR"/config/xyz.omp.json

progress "devenv_tools.bash"
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.bash -o "$DESTDIR"/devenv_tools.bash

progress "devenv_tools.zsh"
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.zsh -o "$DESTDIR"/devenv_tools.zsh

progress "gitconfig"
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/gitconfig -o "$DESTDIR"/gitconfig

progress "zsh-autosuggestions"
curl -Ls https://github.com/zsh-users/zsh-autosuggestions/archive/master.tar.gz | tar xfz - --strip-components=1 -C "$DESTDIR"/zsh-autosuggestions

progress "done"

echo ""
echo "Add the following line to ~/.zshrc"
echo "  source $DESTDIR/devenv_tools.zsh"
echo "Add the following line to ~/.bashrc"
echo "  source $DESTDIR/devenv_tools.bash"
echo "Add the following line to ~/.config/nvim/init.lua"
echo "  require('devenv_config')"
echo "Consider installing"
echo "  pi install npm:pi-blackhole"
echo "  pi install npm:pi-subagents"

