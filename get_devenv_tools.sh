#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 <install-dir>"
  exit 1
fi

echo "Downloading tools..."
LLAMA_VERSION=$(curl -s https://api.github.com/repos/ggml-org/llama.cpp/releases/latest | jq -r .tag_name)

if [[ "$(uname)" == "Darwin" ]]; then
  DESTDIR="$(realpath "$1")"
  mkdir -p "$DESTDIR"/llama.cpp
  curl -sL https://github.com/BenjaminKern/devenv-tools/releases/download/latest/devenv-tools-aarch64-macos.tar.xz | tar xfJ - --strip=1 -C "$DESTDIR"
  curl -sL https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.darwin.aarch64.tar.xz | tar xfJ - --strip=1 -C "$DESTDIR"/bin
  curl -Ls https://github.com/ggml-org/llama.cpp/releases/download/${LLAMA_VERSION}/llama-${LLAMA_VERSION}-bin-macos-arm64.zip | tar xfz - --strip=1 -C "$DESTDIR"/llama.cpp
  curl -Ls https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz | tar xfz - -C "$DESTDIR"
  chmod u+x "$DESTDIR"/llama.cpp/bin/llama-*
else
  DESTDIR="$(readlink -e "$1")"
  curl -sL https://github.com/BenjaminKern/devenv-tools/releases/download/latest/devenv-tools-x86_64-linux.tar.xz | tar xfJ - --strip=1 -C "$DESTDIR"
  curl -sL https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.linux.x86_64.tar.xz | tar xfJ - --strip=1 -C "$DESTDIR"/bin
  curl -Ls https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 -o "$DESTDIR"/bin/hadolint
  chmod u+x "$DESTDIR"/bin/hadolint
fi

mkdir -p "$DESTDIR"/{config,zsh-autosuggestions}
mkdir -p "$DESTDIR"/share/nvim/runtime/snippets

echo "Downloading config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o "$DESTDIR"/share/nvim/runtime/lua/devenv_config.lua
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/all.json -o "$DESTDIR"/share/nvim/runtime/snippets/all.json
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.json -o "$DESTDIR"/share/nvim/runtime/snippets/cpp.json
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore -o "$DESTDIR"/share/nvim/.fd-ignore
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/refs/heads/main/.config/xyz.omp.json -o "$DESTDIR"/config/xyz.omp.json

echo "Downloading devenv_tools.bash..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.bash -o "$DESTDIR"/devenv_tools.bash
echo "Downloading devenv_tools.zsh..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/devenv_tools.zsh -o "$DESTDIR"/devenv_tools.zsh

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
