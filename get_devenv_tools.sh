#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

if [[ -z "${1:-}" ]] || [[ -z "${2:-}" ]]; then
  echo "Usage: $0 <install-dir> <target>"
  echo "Valid targets: aarch64-macos, aarch64-linux, x86_64-linux"
  exit 1
fi

LIMA_VERSION="v2.0.0"
LLAMA_VERSION="b8373"
SHELLCHECK_VERSION="v0.11.0"
HADOLINT_VERSION="v2.14.0"
ZMX_VERSION="0.4.1"
COPILOT_CLI_VERSION="v1.0.5"

case "$2" in
  aarch64-macos)
    DEVENV_SUFFIX="aarch64-macos"
    SHELLCHECK_ARCH="darwin.aarch64"
    HADOLINT_SUFFIX="Darwin-arm64"
    LLAMA_SUFFIX="macos-arm64"
    LIMA_SUFFIX="Darwin-arm64"
    ZMX_SUFFIX="macos-aarch64"
    COPILOT_SUFFIX="darwin-arm64"
    ;;
  aarch64-linux)
    DEVENV_SUFFIX="aarch64-linux"
    SHELLCHECK_ARCH="linux.aarch64"
    HADOLINT_SUFFIX="Linux-arm64"
    LIMA_SUFFIX="Linux-aarch64"
    ZMX_SUFFIX="linux-aarch64"
    COPILOT_SUFFIX="linux-arm64"
    ;;
  x86_64-linux)
    DEVENV_SUFFIX="x86_64-linux"
    SHELLCHECK_ARCH="linux.x86_64"
    HADOLINT_SUFFIX="Linux-x86_64"
    LIMA_SUFFIX="Linux-x86_64"
    ZMX_SUFFIX="linux-x86_64"
    COPILOT_SUFFIX="linux-x64"
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
if [[ "$2" == "aarch64-macos" ]]; then
  TOTAL=14
fi

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

progress "lima ${LIMA_VERSION}"
curl -sL "https://github.com/lima-vm/lima/releases/download/${LIMA_VERSION}/lima-${LIMA_VERSION#v}-${LIMA_SUFFIX}.tar.gz" | tar xfz - --strip=1 -C "$DESTDIR"

progress "zmx ${ZMX_VERSION}"
curl -Ls "https://zmx.sh/a/zmx-${ZMX_VERSION}-${ZMX_SUFFIX}.tar.gz" | tar xfz - -C "$DESTDIR"/bin

progress "copilot-cli ${COPILOT_CLI_VERSION}"
curl -sL "https://github.com/github/copilot-cli/releases/download/${COPILOT_CLI_VERSION}/copilot-${COPILOT_SUFFIX}.tar.gz" | tar xfz - -C "$DESTDIR"/bin

if [[ "$2" == "aarch64-macos" ]]; then
  progress "llama.cpp ${LLAMA_VERSION}"
  mkdir -p "$DESTDIR"/llama.cpp
  curl -Ls "https://github.com/ggml-org/llama.cpp/releases/download/${LLAMA_VERSION}/llama-${LLAMA_VERSION}-bin-${LLAMA_SUFFIX}.tar.gz" | tar xfz - --strip=1 -C "$DESTDIR"/llama.cpp
fi

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
