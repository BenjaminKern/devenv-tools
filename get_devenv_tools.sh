#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob
set -x

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 <install-dir>"
  exit 1
fi

echo "Downloading tools..."
LIMA_VERSION="v2.0.0"
LLAMA_VERSION="b8373"
SHELLCHECK_VERSION="v0.11.0"
HADOLINT_VERSION="v2.14.0"
ZMX_VERSION="0.4.1"
COPILOT_CLI_VERSION="v1.0.5"

if [[ "$(uname)" == "Darwin" ]]; then
  DESTDIR="$(realpath "$1")"
  NVIM_CONFIG_DIR="${DESTDIR}"
  mkdir -p "$DESTDIR"/llama.cpp
  curl -sL https://github.com/BenjaminKern/devenv-tools/releases/download/latest/devenv-tools-aarch64-macos.tar.xz | tar xfJ - --strip=1 -C "$DESTDIR"
  curl -sL "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.darwin.aarch64.tar.xz" | tar xfJ - --strip=1 -C "$DESTDIR"/bin
  curl -Ls https://github.com/ggml-org/llama.cpp/releases/download/${LLAMA_VERSION}/llama-${LLAMA_VERSION}-bin-macos-arm64.tar.gz | tar xfz - --strip=1 -C "$DESTDIR"/llama.cpp
  curl -Ls "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Darwin-arm64" -o "$DESTDIR"/bin/hadolint
  chmod u+x "$DESTDIR"/bin/hadolint
  curl -sL https://github.com/lima-vm/lima/releases/download/${LIMA_VERSION}/lima-${LIMA_VERSION#v}-Darwin-arm64.tar.gz | tar xfz - --strip=1 -C "$DESTDIR"
  curl -Ls "https://zmx.sh/a/zmx-${ZMX_VERSION}-macos-aarch64.tar.gz" | tar xfz - -C "$DESTDIR"/bin
  curl -sL "https://github.com/github/copilot-cli/releases/download/${COPILOT_CLI_VERSION}/copilot-darwin-arm64.tar.gz" | tar xfz - -C "$DESTDIR"/bin
else
  DESTDIR="$(readlink -e "$1")"
  NVIM_CONFIG_DIR="${DESTDIR}"
  ARCH="$(uname -m)"
  if [[ "$ARCH" == "aarch64" ]]; then
    DEVENV_SUFFIX="aarch64-linux"
    SHELLCHECK_ARCH="linux.aarch64"
    HADOLINT_SUFFIX="Linux-arm64"
    LIMA_SUFFIX="Linux-aarch64"
    ZMX_SUFFIX="linux-aarch64"
    COPILOT_SUFFIX="linux-arm64"
  else
    DEVENV_SUFFIX="x86_64-linux"
    SHELLCHECK_ARCH="linux.x86_64"
    HADOLINT_SUFFIX="Linux-x86_64"
    LIMA_SUFFIX="Linux-x86_64"
    ZMX_SUFFIX="linux-x86_64"
    COPILOT_SUFFIX="linux-x64"
  fi
  curl -sL "https://github.com/BenjaminKern/devenv-tools/releases/download/latest/devenv-tools-${DEVENV_SUFFIX}.tar.xz" | tar xfJ - --strip=1 -C "$DESTDIR"
  curl -sL "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.${SHELLCHECK_ARCH}.tar.xz" | tar xfJ - --strip=1 -C "$DESTDIR"/bin
  curl -Ls "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-${HADOLINT_SUFFIX}" -o "$DESTDIR"/bin/hadolint
  chmod u+x "$DESTDIR"/bin/hadolint
  curl -sL "https://github.com/lima-vm/lima/releases/download/${LIMA_VERSION}/lima-${LIMA_VERSION#v}-${LIMA_SUFFIX}.tar.gz" | tar xfz - --strip=1 -C "$DESTDIR"
  curl -Ls "https://zmx.sh/a/zmx-${ZMX_VERSION}-${ZMX_SUFFIX}.tar.gz" | tar xfz - -C "$DESTDIR"/bin
  curl -sL "https://github.com/github/copilot-cli/releases/download/${COPILOT_CLI_VERSION}/copilot-${COPILOT_SUFFIX}.tar.gz" | tar xfz - -C "$DESTDIR"/bin
fi

mkdir -p "$DESTDIR"/{config,zsh-autosuggestions}
mkdir -p "$NVIM_CONFIG_DIR"/share/nvim/runtime/snippets

echo "Downloading config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o "$NVIM_CONFIG_DIR"/share/nvim/runtime/lua/devenv_config.lua
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/all.json -o "$NVIM_CONFIG_DIR"/share/nvim/runtime/snippets/all.json
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.json -o "$NVIM_CONFIG_DIR"/share/nvim/runtime/snippets/cpp.json
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore -o "$DESTDIR"/share/nvim/.fd-ignore
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/refs/heads/main/.config/xyz.omp.json -o "$DESTDIR"/config/xyz.omp.json

echo "Downloading devenv_tools.bash..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.bash -o "$DESTDIR"/devenv_tools.bash
echo "Downloading devenv_tools.zsh..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.zsh -o "$DESTDIR"/devenv_tools.zsh

echo "Downloading gitconfig..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/gitconfig -o "$DESTDIR"/gitconfig

echo "Downloading github copilot auth tool..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/github_copilot_auth -o "$DESTDIR"/bin/github_copilot_auth
chmod u+x "$DESTDIR"/bin/github_copilot_auth

echo "Downloading zsh-autosuggestions..."
curl -Ls https://github.com/zsh-users/zsh-autosuggestions/archive/master.tar.gz | tar xfz - --strip-components=1 -C "$DESTDIR"/zsh-autosuggestions

echo "Add the following line to ~/.zshrc"
echo "source $DESTDIR/devenv_tools.zsh"
echo "Add the following line to ~/.bashrc"
echo "source $DESTDIR/devenv_tools.bash"
echo "Add the following line to ~/.config/nvim/init.lua"
echo "require('devenv_config')"
