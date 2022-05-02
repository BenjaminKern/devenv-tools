devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return

PATH=$devenv_tools_dir/bin:$PATH
source $devenv_tools_dir/config/fzf-key-bindings.bash
export FZF_DEFAULT_COMMAND="fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"
export STARSHIP_CONFIG=$devenv_tools_dir/config/starship.toml
export LS_COLORS="$(vivid generate gruvbox-dark)"
alias ls='lsd'
alias ff="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --bind ctrl-alt-k:preview-page-up,ctrl-alt-j:preview-page-down"
export EDITOR=nvim
alias cat='bat --paging=never'

[[ -v devenv_tools_proxy ]] && \
  export HTTP_PROXY=$devenv_tools_proxy && \
  export HTTPS_PROXY=$devenv_tools_proxy && \
  export http_proxy=$devenv_tools_proxy && \
  export https_proxy=$devenv_tools_proxy

source $devenv_tools_dir/bin/autocomplete/bat.bash
source $devenv_tools_dir/bin/autocomplete/fd.bash
source $devenv_tools_dir/bin/autocomplete/hyperfine.bash
source $devenv_tools_dir/bin/autocomplete/lsd.bash-completion
source $devenv_tools_dir/bin/autocomplete/fzf.bash-completion
source $devenv_tools_dir/bin/complete/rg.bash

# tab completion
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"
# history
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
HISTTIMEFORMAT='%F %T '
alias for_all_files='fd --type f -x'
alias find_and_replace='fd --type f -x sd'
alias clang_format_files='fd -e h -e cpp -e c -x clang-format -i'

eval "$(zoxide init --cmd j bash)"
eval "$(starship init bash)"
