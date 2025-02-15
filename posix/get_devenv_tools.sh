#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

# Define versions
NVIM_VERSION="nightly"
CLANGD_VERSION="19.1.2"
RIPGREP_VERSION="14.1.1"
FZF_VERSION="0.59.0"
HEXYL_VERSION="0.16.0"
HYPERFINE_VERSION="1.19.0"
FD_VERSION="10.2.0"
BAT_VERSION="0.25.0"
SD_VERSION="1.0.0"
STARSHIP_VERSION="1.21.1"
LSD_VERSION="1.1.5"
GOJQ_VERSION="0.12.17"
AGE_VERSION="1.2.0"
ZOXIDE_VERSION="0.9.6"
DELTA_VERSION="0.18.2"
WATCHEXEC_VERSION="2.2.1"
STYLUA_VERSION="2.0.2"
DENO_VERSION="2.1.4"
BUILDIFIER_VERSION="7.3.1"
FASTFETCH_VERSION="2.33.0"
LIMA_VERSION="1.0.2"
BOTTOM_VERSION="0.10.2"
DISKUS_VERSION="0.8.0"
RUFF_VERSION="0.9.2"
UV_VERSION="0.5.20"
STARPLS_VERSION="0.1.21"
SHFMT_VERSION="3.10.0"

IS_OSX=0

DESTDIR=""

if [[ "$(uname)" == "Darwin" ]]; then
	DESTDIR="$(realpath $1)"
	IS_OSX=1
else
	DESTDIR="$(readlink -e $1)"
fi

mkdir -p $DESTDIR/bin
PATH=$DESTDIR/bin:$PATH
mkdir -p $DESTDIR/cpptools
mkdir -p $DESTDIR/config
mkdir -p $DESTDIR/zsh-autosuggestions
mkdir -p $DESTDIR/share/nvim/sessions
mkdir -p $DESTDIR/share/nvim/runtime/snippets

echo "Downloading nvim..."
if [[ $IS_OSX -eq 1 ]]; then
	curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR
else
	curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR
fi

echo "Downloading lldb..."
if [[ $IS_OSX -eq 1 ]]; then
        curl -sL https://github.com/BenjaminKern/llvm-binaries/releases/download/v19.1.7/lldb-aarch64-macos.tar.gz | tar xfz - -C $DESTDIR/bin
else
        curl -sL https://github.com/BenjaminKern/llvm-binaries/releases/download/v19.1.7/lldb-x86_64-linux.tar.gz | tar xfz - -C $DESTDIR/bin
fi

echo "Downloading neovim config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o $DESTDIR/share/nvim/runtime/lua/devenv_config.lua
echo "Downloading neovim snippets..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/_.snippets -o $DESTDIR/share/nvim/runtime/snippets/_.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/c.snippets -o $DESTDIR/share/nvim/runtime/snippets/c.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.snippets -o $DESTDIR/share/nvim/runtime/snippets/cpp.snippets
echo "Downloading fd ignore file..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore -o $DESTDIR/share/nvim/.fd-ignore
echo "Downloading starship.toml..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/starship.toml -o $DESTDIR/config/starship.toml
echo "Downloading devenv_tools.bash..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/posix/devenv_tools.bash -o $DESTDIR/devenv_tools.bash
echo "Downloading devenv_tools.zsh..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/posix/devenv_tools.zsh -o $DESTDIR/devenv_tools.zsh

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

echo "Downloading ruff..."
APPLICATION_NAME=ruff-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=ruff-aarch64-apple-darwin
fi
curl -sL "https://github.com/astral-sh/ruff/releases/download/$RUFF_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading uv..."
APPLICATION_NAME=uv-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=uv-aarch64-apple-darwin
fi
curl -sL "https://github.com/astral-sh/uv/releases/download/$UV_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading starpls..."
APPLICATION_NAME=starpls-linux-amd64
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=starpls-darwin-arm64
fi
curl -sL "https://github.com/withered-magic/starpls/releases/download/v$STARPLS_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - -C $DESTDIR/bin

echo "Downloading fzf..."
APPLICATION_NAME=fzf-$FZF_VERSION-linux_amd64
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=fzf-$FZF_VERSION-darwin_arm64
fi
curl -sL "https://github.com/junegunn/fzf/releases/download/v$FZF_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - -C $DESTDIR/bin

echo "Downloading hyperfine..."
APPLICATION_NAME=hyperfine-v$HYPERFINE_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=hyperfine-v$HYPERFINE_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/sharkdp/hyperfine/releases/download/v$HYPERFINE_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading bat..."
APPLICATION_NAME=bat-v$BAT_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=bat-v$BAT_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading fd..."
APPLICATION_NAME=fd-v$FD_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=fd-v$FD_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/sharkdp/fd/releases/download/v$FD_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

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
echo "Downloading gojq..."
APPLICATION_NAME=gojq_v${GOJQ_VERSION}_linux_amd64.tar.gz
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=gojq_v${GOJQ_VERSION}_darwin_arm64.zip
fi
curl -sL "https://github.com/itchyny/gojq/releases/download/v$GOJQ_VERSION/$APPLICATION_NAME" | bsdtar xf - --strip-components=1 -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/gojq

echo "Downloading age..."
APPLICATION_NAME=age-v$AGE_VERSION-linux-amd64
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=age-v$AGE_VERSION-darwin-arm64
fi
curl -sL "https://github.com/FiloSottile/age/releases/download/v$AGE_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading zoxide..."
APPLICATION_NAME=zoxide-$ZOXIDE_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=zoxide-$ZOXIDE_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/ajeetdsouza/zoxide/releases/download/v$ZOXIDE_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - -C $DESTDIR/bin

echo "Downloading delta..."
APPLICATION_NAME=delta-$DELTA_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=delta-$DELTA_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/dandavison/delta/releases/download/$DELTA_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading watchexec..."
APPLICATION_NAME=watchexec-$WATCHEXEC_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=watchexec-$WATCHEXEC_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/watchexec/watchexec/releases/download/v$WATCHEXEC_VERSION/$APPLICATION_NAME.tar.xz" | tar xfJ - --strip-components=1 -C $DESTDIR/bin

echo "Downloading stylua..."
APPLICATION_NAME=stylua-linux-x86_64-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=stylua-macos-aarch64
fi
curl -sL "https://github.com/JohnnyMorganz/StyLua/releases/download/v$STYLUA_VERSION/$APPLICATION_NAME.zip" | bsdtar xf - -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/stylua

echo "Downloading deno..."
APPLICATION_NAME=deno-x86_64-unknown-linux-gnu
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=deno-aarch64-apple-darwin
fi
curl -Ls "https://github.com/denoland/deno/releases/download/v$DENO_VERSION/deno-x86_64-unknown-linux-gnu.zip" | bsdtar xf - -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/deno

echo "Downloading buildifier..."
APPLICATION_NAME=buildifier-linux-amd64
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=buildifier-darwin-arm64
fi
curl -Ls "https://github.com/bazelbuild/buildtools/releases/download/v$BUILDIFIER_VERSION/$APPLICATION_NAME" -o $DESTDIR/bin/buildifier
chmod u+x $DESTDIR/bin/buildifier

echo "Downloading bazelisk..."
APPLICATION_NAME=bazelisk-linux-amd64
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=bazelisk-darwin-arm64
fi
curl -Ls "https://github.com/bazelbuild/bazelisk/releases/download/v1.25.0/$APPLICATION_NAME" -o $DESTDIR/bin/bazelisk
chmod u+x $DESTDIR/bin/bazelisk

echo "Downloading fastfetch..."
APPLICATION_NAME=fastfetch-linux-amd64
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=fastfetch-macos-universal
fi
curl -sL "https://github.com/fastfetch-cli/fastfetch/releases/download/$FASTFETCH_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=2 -C $DESTDIR

echo "Downloading bottom..."
APPLICATION_NAME=bottom_x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=bottom_aarch64-apple-darwin
fi
curl -sL "https://github.com/ClementTsang/bottom/releases/download/$BOTTOM_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - -C $DESTDIR/bin

echo "Downloading hexyl..."
APPLICATION_NAME=hexyl-v$HEXYL_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=hexyl-v$HEXYL_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/sharkdp/hexyl/releases/download/v$HEXYL_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading diskus..."
APPLICATION_NAME=diskus-v$DISKUS_VERSION-x86_64-unknown-linux-musl
if [[ $IS_OSX -eq 1 ]]; then
	APPLICATION_NAME=diskus-v$DISKUS_VERSION-aarch64-apple-darwin
fi
curl -sL "https://github.com/sharkdp/diskus/releases/download/v$DISKUS_VERSION/$APPLICATION_NAME.tar.gz" | tar xfz - --strip-components=1 -C $DESTDIR/bin

echo "Downloading zsh-autosuggestions..."
curl -Ls https://github.com/zsh-users/zsh-autosuggestions/archive/master.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/zsh-autosuggestions

echo "Downloading shfmt..."
APPLICATION_NAME=shfmt_v$SHFMT_VERSION-linux_amd64
if [[ $IS_OSX -eq 1 ]]; then
	curl -sL https://github.com/mvdan/sh/releases/download/v3.10.0/shfmt_v3.10.0_darwin_arm64 -o $DESTDIR/bin/shfmt
else
	curl -sL https://github.com/mvdan/sh/releases/download/v3.10.0/shfmt_v3.10.0_linux_amd64 -o $DESTDIR/bin/shfmt
fi
chmod u+x "$DESTDIR"/bin/shfmt

if [[ $IS_OSX -eq 1 ]]; then
	echo "Downloading lima..."
	mkdir -p $DESTDIR/lima
	curl -Ls https://github.com/lima-vm/lima/releases/download/v$LIMA_VERSION/lima-$LIMA_VERSION-Darwin-arm64.tar.gz | tar xfz - -C $DESTDIR/lima
else
	echo "Downloading hadolint"
	curl -Ls https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 -o $DESTDIR/bin/hadolint
	chmod u+x $DESTDIR/bin/hadolint
fi

echo "Add the following line to ~/.zshrc"
echo "source $DESTDIR/devenv_tools.zsh"
echo "Add the following line to ~/.bashrc"
echo "source $DESTDIR/devenv_tools.bash"
echo "Add the following line to ~/.config/nvim/init.lua"
echo "require('devenv_config')"
