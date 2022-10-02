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
curl -sL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR
echo "Downloading vim plugged..."
curl -sL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o $DESTDIR/share/nvim/runtime/pack/dist/opt/plug/plugin/plug.vim --create-dirs
echo "Downloading neovim config..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/devenv_config.lua -o $DESTDIR/share/nvim/runtime/lua/devenv_config.lua
echo "Downloading neovim snippets..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/_.snippets -o $DESTDIR/share/nvim/runtime/snippets/_.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/c.snippets -o $DESTDIR/share/nvim/runtime/snippets/c.snippets
curl -sL https://raw.githubusercontent.com/BenjaminKern/dotfiles/main/.config/nvim/snippets/cpp.snippets -o $DESTDIR/share/nvim/runtime/snippets/cpp.snippets
echo "Downloading clangd..."
curl -sL https://github.com/clangd/clangd/releases/download/15.0.1/clangd-linux-15.0.1.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
echo "Downloading clangd indexer..."
curl -sL https://github.com/clangd/clangd/releases/download/15.0.1/clangd_indexing_tools-linux-15.0.1.zip | bsdtar xf - --strip-components=1 -C $DESTDIR
chmod u+x $DESTDIR/bin/clangd*
echo "Downloading ripgrep..."
curl -sL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fzf..."
curl -sL https://github.com/junegunn/fzf/releases/download/0.34.0/fzf-0.34.0-linux_amd64.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading hexyl..."
curl -sL https://github.com/sharkdp/hexyl/releases/download/v0.10.0/hexyl-v0.10.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading hyperfine..."
curl -sL https://github.com/sharkdp/hyperfine/releases/download/v1.15.0/hyperfine-v1.15.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading fd..."
curl -sL https://github.com/sharkdp/fd/releases/download/v8.4.0/fd-v8.4.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading bat..."
curl -sL https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-v0.22.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading vivid..."
curl -sL https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid-v0.8.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading sd..."
curl -sL https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-musl -o $DESTDIR/bin/sd
chmod u+x $DESTDIR/bin/sd
echo "Downloading starship..."
curl -sL https://github.com/starship/starship/releases/download/v1.10.3/starship-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading lsd..."
curl -sL https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd-0.23.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading dust..."
curl -sL https://github.com/bootandy/dust/releases/download/v0.8.3/dust-v0.8.3-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading gojq..."
curl -sL https://github.com/itchyny/gojq/releases/download/v0.12.9/gojq_v0.12.9_linux_amd64.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading btop..."
curl -sL https://github.com/aristocratos/btop/releases/download/v1.2.9/btop-x86_64-linux-musl.tbz | bsdtar xfj - --strip-components=1 -C $DESTDIR/bin
echo "Downloading age..."
curl -sL https://github.com/FiloSottile/age/releases/download/v1.0.0/age-v1.0.0-linux-amd64.tar.gz| bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading gdbinit-gef..."
curl -sL https://raw.githubusercontent.com/hugsy/gef/dev/gef.py -o $DESTDIR/config/gdbinit-gef.py
echo "Downloading zoxide..."
curl -sL https://github.com/ajeetdsouza/zoxide/releases/download/v0.8.3/zoxide-0.8.3-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - -C $DESTDIR/bin
echo "Downloading delta..."
curl -sL https://github.com/dandavison/delta/releases/download/0.14.0/delta-0.14.0-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading ttyd..."
curl -sL https://github.com/tsl0922/ttyd/releases/download/1.7.1/ttyd.x86_64 -o $DESTDIR/bin/ttyd
chmod u+x $DESTDIR/bin/ttyd
echo "Downloading watchexec..."
curl -sL https://github.com/watchexec/watchexec/releases/download/cli-v1.20.5/watchexec-1.20.5-x86_64-unknown-linux-musl.tar.xz | bsdtar xfJ - --strip-components=1 -C $DESTDIR/bin
echo "Downloading stylua..."
curl -sL https://github.com/JohnnyMorganz/StyLua/releases/download/v0.15.1/stylua-linux.zip | bsdtar xf - -C $DESTDIR/bin
chmod u+x $DESTDIR/bin/stylua
echo "Downloading xh..."
curl -Ls https://github.com/ducaale/xh/releases/download/v0.16.1/xh-v0.16.1-x86_64-unknown-linux-musl.tar.gz | bsdtar xfz - --strip-components=1 -C $DESTDIR/bin
echo "Downloading lldb..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/linux/bin/lldb-bin.tar.xz | bsdtar xfJ - --strip-components=1 -C $DESTDIR/bin
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
echo "Downloading tmux.conf.common..."
curl -sL https://raw.githubusercontent.com/BenjaminKern/devenv-tools/main/linux/tmux.conf.common -o $DESTDIR/tmux.conf.common

echo "Add the following line to ~/.bashrc"
echo "source $DESTDIR/devenv_tools.bash"
echo "Add the following line to ~/.gdbinit"
echo "source $DESTDIR/config/gdbinit-gef.py"
echo "Add the following line to ~/.config/nvim/init.lua"
echo "require('devenv_config')"
echo "Add the following line to ~/.tmux.conf"
echo "source-file $DESTDIR/tmux.conf.common"
