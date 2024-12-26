#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

IS_OSX=0

if [[ "$(uname)" == "Darwin" ]]; then
    IS_OSX=1
fi

# Define versions
NVIM_VERSION="nightly"
CLANGD_VERSION="19.1.0"
RIPGREP_VERSION="14.1.1"
FZF_VERSION="0.56.0"
HEXYL_VERSION="0.15.0"
HYPERFINE_VERSION="1.18.0"
FD_VERSION="10.2.0"
BAT_VERSION="0.24.0"
VIVID_VERSION="0.10.1"
SD_VERSION="1.0.0"
STARSHIP_VERSION="1.21.1"
LSD_VERSION="1.1.5"
DUST_VERSION="1.1.1"
GOJQ_VERSION="0.12.16"
BTOP_VERSION="1.4.0"
AGE_VERSION="1.2.0"
ZOXIDE_VERSION="0.9.6"
DELTA_VERSION="0.18.2"
WATCHEXEC_VERSION="2.2.0"
STYLUA_VERSION="0.20.0"
DENO_VERSION="2.0.4"
BUILDIFIER_VERSION="7.3.1"

DESTDIR="$(readlink -e $1)"
# DESTDIR="$(realpath $1)"

mkdir -p $DESTDIR/bin
PATH=$DESTDIR/bin:$PATH
mkdir -p $DESTDIR/cpptools
mkdir -p $DESTDIR/config
mkdir -p $DESTDIR/share/nvim/sessions
mkdir -p $DESTDIR/share/nvim/runtime/snippets

echo "Downloading nvim..."
APPLICATION_NAME=nvim-linux64
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=nvim-macos-arm64
fi
curl -sL "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR
echo "Downloading neovim config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o $DESTDIR/share/nvim/runtime/lua/devenv_config.lua
echo "Downloading colorscheme..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/colors/xyztokyo.lua -o $DESTDIR/share/nvim/runtime/colors/xyztokyo.lua
echo "Downloading neovim snippets..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/_.snippets -o $DESTDIR/share/nvim/runtime/snippets/_.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/c.snippets -o $DESTDIR/share/nvim/runtime/snippets/c.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.snippets -o $DESTDIR/share/nvim/runtime/snippets/cpp.snippets
echo "Downloading clangd..."
APPLICATION_NAME=clangd-linux
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=clangd-mac
fi
curl -sL "https://github.com/clangd/clangd/releases/download/$CLANGD_VERSION/$APPLICATION_NAME-$CLANGD_VERSION.zip" | bsdtar xf - --strip-components=1 -C $DESTDIR
echo "Downloading clangd indexer..."
APPLICATION_NAME=clangd_indexing_tools-linux
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=clangd_indexing_tools-mac
fi
curl -sL "https://github.com/clangd/clangd/releases/download/$CLANGD_VERSION/$APPLICATION_NAME-$CLANGD_VERSION.zip" | bsdtar xf - --strip-components=1 -C $DESTDIR
chmod u+x $DESTDIR/bin/clangd*
echo "Downloading ripgrep..."
APPLICATION_NAME=ripgrep-$RIPGREP_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=ripgrep-$RIPGREP_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/BurntSushi/ripgrep/releases/download/$RIPGREP_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fzf..."
APPLICATION_NAME=fzf-$FZF_VERSION-linux_amd64
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=fzf-$FZF_VERSION-darwin_arm64
fi
curl -sL "https://github.com/junegunn/fzf/releases/download/v$FZF_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - -C $DESTDIR/bin

if [[ $IS_OSX -eq 0 ]]; then
echo "Downloading hexyl..."
curl -sL "https://github.com/sharkdp/hexyl/releases/download/v$HEXYL_VERSION/hexyl-v$HEXYL_VERSION-x86_64-unknown-linux-musl.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
fi

echo "Downloading hyperfine..."
APPLICATION_NAME=hyperfine-v$HYPERFINE_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=hyperfine-v$HYPERFINE_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/sharkdp/hyperfine/releases/download/v$HYPERFINE_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fd..."
APPLICATION_NAME=fd-v$FD_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=fd-v$FD_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/sharkdp/fd/releases/download/v$FD_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

if [[ $IS_OSX -eq 0 ]]; then
  echo "Downloading bat..."
  curl -sL "https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-x86_64-unknown-linux-musl.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
  echo "Downloading vivid..."
  curl -sL "https://github.com/sharkdp/vivid/releases/download/v$VIVID_VERSION/vivid-v$VIVID_VERSION-x86_64-unknown-linux-musl.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
fi

echo "Downloading sd..."
APPLICATION_NAME=sd-v$SD_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=sd-v$SD_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/chmln/sd/releases/download/v$SD_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/sd

echo "Downloading starship..."
APPLICATION_NAME=starship-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=starship-aarch64-apple-darwin
fi
curl -sL "https://github.com/starship/starship/releases/download/v$STARSHIP_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - -C $DESTDIR/bin
echo "Downloading lsd..."
APPLICATION_NAME=lsd-v$LSD_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
  APPLICATION_NAME=lsd-v$LSD_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/lsd-rs/lsd/releases/download/v$LSD_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading dust..."
curl -sL "https://github.com/bootandy/dust/releases/download/v$DUST_VERSION/dust-v$DUST_VERSION-x86_64-unknown-linux-musl.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading gojq..."
curl -sL "https://github.com/itchyny/gojq/releases/download/v$GOJQ_VERSION/gojq_v$GOJQ_VERSION_linux_amd64.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
# https://github.com/itchyny/gojq/releases/download/v0.12.17/gojq_v0.12.17_darwin_arm64.zip
echo "Downloading btop..."
curl -sL "https://github.com/aristocratos/btop/releases/download/v$BTOP_VERSION/btop-x86_64-linux-musl.tbz" | tar xfj - --strip-components=2 -C $DESTDIR
echo "Downloading age..."
curl -sL "https://github.com/FiloSottile/age/releases/download/v$AGE_VERSION/age-v$AGE_VERSION-linux-amd64.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
# https://github.com/FiloSottile/age/releases/download/v1.2.1/age-v1.2.1-darwin-arm64.tar.gz
echo "Downloading zoxide..."
curl -sL "https://github.com/ajeetdsouza/zoxide/releases/download/v$ZOXIDE_VERSION/zoxide-$ZOXIDE_VERSION-x86_64-unknown-linux-musl.tar.gz" | tar xfz - -C $DESTDIR/bin
# https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.6/zoxide-0.9.6-aarch64-apple-darwin.tar.gz
echo "Downloading delta..."
curl -sL "https://github.com/dandavison/delta/releases/download/$DELTA_VERSION/delta-$DELTA_VERSION-x86_64-unknown-linux-musl.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin
# https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-aarch64-apple-darwin.tar.gz
echo "Downloading watchexec..."
curl -sL "https://github.com/watchexec/watchexec/releases/download/v$WATCHEXEC_VERSION/watchexec-$WATCHEXEC_VERSION-x86_64-unknown-linux-musl.tar.xz" | tar xfJ - --strip-components=1 -C $DESTDIR/bin
# https://github.com/watchexec/watchexec/releases/download/v2.2.1/watchexec-2.2.1-aarch64-apple-darwin.tar.xz
echo "Downloading stylua..."
curl -sL "https://github.com/JohnnyMorganz/StyLua/releases/download/v$STYLUA_VERSION/stylua-linux-x86_64-musl.zip" | bsdtar xf - -C $DESTDIR/bin
# https://github.com/JohnnyMorganz/StyLua/releases/download/v2.0.2/stylua-macos-aarch64.zip
chmod u+x $DESTDIR/bin/stylua
echo "Downloading deno..."
curl -Ls "https://github.com/denoland/deno/releases/download/v$DENO_VERSION/deno-x86_64-unknown-linux-gnu.zip" | bsdtar xf - -C $DESTDIR/bin
# https://github.com/denoland/deno/releases/download/v2.1.4/deno-aarch64-apple-darwin.zip
chmod u+x $DESTDIR/bin/deno
echo "Downloading buildifier..."
curl -Ls "https://github.com/bazelbuild/buildtools/releases/download/v$BUILDIFIER_VERSION/buildifier-linux-amd64" -o $DESTDIR/bin/buildifier
chmod u+x $DESTDIR/bin/buildifier
# https://github.com/bazelbuild/buildtools/releases/download/v7.3.1/buildifier-darwin-arm64
#https://github.com/bazelbuild/bazelisk/releases/download/v1.25.0/bazelisk-linux-amd64
# https://github.com/bazelbuild/bazelisk/releases/download/v1.25.0/bazelisk-darwin-arm64
