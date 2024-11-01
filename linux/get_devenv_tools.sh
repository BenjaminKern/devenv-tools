#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar
DESTDIR="$(readlink -e $1)"

mkdir -p $DESTDIR/bin
PATH=$DESTDIR/bin:$PATH
mkdir -p $DESTDIR/config
mkdir -p $DESTDIR/share/nvim/sessions
mkdir -p $DESTDIR/share/nvim/runtime/snippets

echo "Downloading nvim..."
curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR
echo "Downloading neovim config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o $DESTDIR/share/nvim/runtime/lua/devenv_config.lua
echo "Downloading colorscheme..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/colors/xyztokyo.lua -o $DESTDIR/share/nvim/runtime/colors/xyztokyo.lua
echo "Downloading neovim snippets..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/_.snippets -o $DESTDIR/share/nvim/runtime/snippets/_.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/c.snippets -o $DESTDIR/share/nvim/runtime/snippets/c.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.snippets -o $DESTDIR/share/nvim/runtime/snippets/cpp.snippets
echo "Downloading clangd..."
curl -sL https://github.com/clangd/clangd/releases/download/19.1.0/clangd-linux-19.1.0.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
echo "Downloading clangd indexer..."
curl -sL https://github.com/clangd/clangd/releases/download/19.1.0/clangd_indexing_tools-linux-19.1.0.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
chmod u+x $DESTDIR/bin/clangd*
echo "Downloading ripgrep..."
curl -sL https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fzf..."
curl -sL https://github.com/junegunn/fzf/releases/download/v0.56.0/fzf-0.56.0-linux_amd64.tar.gz | tar xfz - -C $DESTDIR/bin
echo "Downloading hexyl..."
curl -sL https://github.com/sharkdp/hexyl/releases/download/v0.15.0/hexyl-v0.15.0-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading hyperfine..."
curl -sL https://github.com/sharkdp/hyperfine/releases/download/v1.18.0/hyperfine-v1.18.0-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fd..."
curl -sL https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading bat..."
curl -sL https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading vivid..."
curl -sL https://github.com/sharkdp/vivid/releases/download/v0.10.1/vivid-v0.10.1-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading sd..."
curl -sL https://github.com/chmln/sd/releases/download/v1.0.0/sd-v1.0.0-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/sd
echo "Downloading starship..."
curl -sL https://github.com/starship/starship/releases/download/v1.21.1/starship-x86_64-unknown-linux-musl.tar.gz | tar xfz - -C $DESTDIR/bin
echo "Downloading lsd..."
curl -sL https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd-v1.1.5-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading dust..."
curl -sL https://github.com/bootandy/dust/releases/download/v1.1.1/dust-v1.1.1-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading gojq..."
curl -sL https://github.com/itchyny/gojq/releases/download/v0.12.16/gojq_v0.12.16_linux_amd64.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading btop..."
curl -sL https://github.com/aristocratos/btop/releases/download/v1.4.0/btop-x86_64-linux-musl.tbz | tar xfj - --strip-components=2 -C $DESTDIR
echo "Downloading age..."
curl -sL https://github.com/FiloSottile/age/releases/download/v1.2.0/age-v1.2.0-linux-amd64.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading gdbinit-gef..."
curl -sL https://raw.githubusercontent.com/hugsy/gef/dev/gef.py -o $DESTDIR/config/gdbinit-gef.py
echo "Downloading zoxide..."
curl -sL https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.6/zoxide-0.9.6-x86_64-unknown-linux-musl.tar.gz | tar xfz - -C $DESTDIR/bin
echo "Downloading delta..."
curl -sL https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading watchexec..."
curl -sL https://github.com/watchexec/watchexec/releases/download/v2.2.0/watchexec-2.2.0-x86_64-unknown-linux-musl.tar.xz | tar xfJ - --strip-components=1 -C $DESTDIR/bin
echo "Downloading stylua..."
curl -sL https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-x86_64-musl.zip | bsdtar xf - -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/stylua
echo "Downloading xh..."
curl -Ls https://github.com/ducaale/xh/releases/download/v0.23.0/xh-v0.23.0-x86_64-unknown-linux-musl.tar.gz | tar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading deno..."
curl -Ls https://github.com/denoland/deno/releases/download/v2.0.4/deno-x86_64-unknown-linux-gnu.zip | bsdtar xf - -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/deno
echo "Downloading denort..."
curl -Ls https://github.com/denoland/deno/releases/download/v2.0.4/denort-x86_64-unknown-linux-gnu.zip | bsdtar xf - -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/denort
curl -Ls https://github.com/bazelbuild/buildtools/releases/download/v7.3.1/buildifier-linux-amd64 -o $DESTDIR/bin/buildifier
chmod u+x $DESTDIR/bin/buildifier
echo "Downloading lldb..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/linux/bin/lldb-bin.tar.xz | tar xfJ - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fzf.keybindings.bash..."
curl -sL https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash -o $DESTDIR/config/fzf-key-bindings.bash
echo "Downloading fzf.completions.bash..."
curl -sL https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash -o $DESTDIR/bin/autocomplete/fzf.bash-completion
echo "Downloading fd ignore file..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/.fd-ignore -o $DESTDIR/share/nvim/.fd-ignore
echo "Downloading devenv_tools.bash..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/linux/devenv_tools.bash -o $DESTDIR/devenv_tools.bash
echo "Downloading starship.toml..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/starship.toml -o $DESTDIR/config/starship.toml

echo "Add the following line to ~/.bashrc"
echo "source $DESTDIR/devenv_tools.bash"
echo "Add the following line to ~/.gdbinit"
echo "source $DESTDIR/config/gdbinit-gef.py"
echo "Add the following line to ~/.config/nvim/init.lua"
echo "require('devenv_config')"
