devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return
export EDITOR=nvim

PATH=$devenv_tools_dir/bin:$PATH
export FZF_DEFAULT_COMMAND="fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"
export STARSHIP_CONFIG=$devenv_tools_dir/config/starship.toml
alias ff='nvim $(tv)'
alias ffg='nvim $(tv text)'
alias ls='lsd'
alias cat='bat --paging=never'
alias gv='tv git-log'

source $devenv_tools_dir/bin/autocomplete/hyperfine.bash
source $devenv_tools_dir/bin/autocomplete/lsd.bash-completion
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
eval "$(bat --completion bash)"
eval "$(tv init bash)"
# eval "$(fd --gen-completions bash)"
eval "$(starship init bash)"
