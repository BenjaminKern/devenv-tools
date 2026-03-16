devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return
export EDITOR=nvim
SHELL="$(command -v bash)"
export SHELL

if [[ -d "$devenv_tools_dir/git/libexec/git-core" ]]; then
  export GIT_EXEC_PATH="$devenv_tools_dir/git/libexec/git-core"
  export GIT_TEMPLATE_DIR="$devenv_tools_dir/git/share/git-core/templates"
  PATH="$devenv_tools_dir/bin:$devenv_tools_dir/git/bin:$PATH"
else
  PATH="$devenv_tools_dir/bin:$PATH"
fi

export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0="include.path"
export GIT_CONFIG_VALUE_0="$devenv_tools_dir/gitconfig"

command -v fd &>/dev/null && export FZF_DEFAULT_COMMAND="fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"
command -v lsd &>/dev/null && alias ls='lsd'
command -v bat &>/dev/null && alias cat='bat --paging=never'

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
  if [[ -n "$1" && -f "$1" ]]; then
    filter="-- $1"
  fi

  git lg "$@" | \
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

if [[ ! -w "${HISTFILE:-$HOME/.bash_history}" ]]; then
  export HISTFILE="${TMPDIR:-/tmp}/.bash_history_$$"
fi

command -v fd &>/dev/null && alias for_all_files='fd --type f -x'
command -v fd &>/dev/null && command -v sd &>/dev/null && alias find_and_replace='fd --type f -x sd'
command -v fd &>/dev/null && alias clang_format_files='fd -e h -e cpp -e c -x clang-format -i'

alias gds='git diff --cached | nvim -'
alias gdm='git diff origin/main | nvim -'
command -v bazel &>/dev/null && alias b='bazel'
command -v bazel &>/dev/null && alias bb='bazel build'
command -v bazel &>/dev/null && alias bt='bazel test'
command -v bazel &>/dev/null && alias br='bazel run'


command -v bat &>/dev/null && eval "$(bat --completion bash)"
command -v fzf &>/dev/null && eval "$(fzf --bash)"
command -v fd &>/dev/null && eval "$(fd --gen-completions bash)"
command -v oh-my-posh &>/dev/null && eval "$(oh-my-posh init bash --config "$devenv_tools_dir/config/xyz.omp.json")"
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd j bash)"
