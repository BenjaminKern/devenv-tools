devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return
export EDITOR=nvim
export SHELL=/bin/bash

if [[ -d "$devenv_tools_dir/git/libexec/git-core" ]]; then
  export GIT_EXEC_PATH="$devenv_tools_dir/git/libexec/git-core"
  export GIT_TEMPLATE_DIR="$devenv_tools_dir/git/share/git-core/templates"
  PATH="$devenv_tools_dir/bin:$devenv_tools_dir/git/bin:$PATH"
else
  PATH="$devenv_tools_dir/bin:$PATH"
fi
export FZF_DEFAULT_COMMAND="fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"
alias ls='lsd'
alias cat='bat --paging=never'

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}
ff() {
    fzf \
      --ansi --no-sort --reverse --tiebreak=index \
      --preview "bat --theme 1337 --style=numbers --color=always --line-range :500 {}" \
      --bind "alt-j:preview-down,alt-k:preview-up,q:abort" \
      --preview-window=right:60%
}
gv() {
  is_in_git_repo || return

  local filter
  if [ -n $@ ] && [ -f $@ ]; then
    filter="-- $@"
  fi

  git lg $@ | \
    fzf \
      --ansi --no-sort --reverse --tiebreak=index \
      --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always --format=fuller \$1 $filter | delta --line-numbers --syntax-theme=OneHalfDark; }; f {}" \
      --bind "alt-j:preview-down,alt-k:preview-up,q:abort" \
      --preview-window=right:60%
}
ffe() {
  rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1}:{2})'
}

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
# eval "$(bat --completion bash)"
eval "$(fzf --bash)"
eval "$(fd --gen-completions bash)"
eval "$(watchexec --completions bash)"
eval "$(oh-my-posh init bash --config $devenv_tools_dir/config/xyz.omp.json)"
