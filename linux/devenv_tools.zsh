devenv_tools_dir="$(cd "$(dirname "${(%):-%N}")" &> /dev/null && pwd)"
if [[ ! -f "$devenv_tools_dir/devenv_tools.zsh" ]]; then
    return
fi
export EDITOR=nvim

setopt nobeep autocd
export CLICOLOR=1
autoload -Uz compinit
fpath=($devenv_tools_dir/bin/autocomplete $devenv_tools_dir/bin/complete $devenv_tools_dir/bin/completions $fpath)
compinit
source $devenv_tools_dir/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#82aaff,bg=#222436,bold,underline"

PATH=$devenv_tools_dir/bin:$devenv_tools_dir/cpptools/debugAdapters/bin:$devenv_tools_dir/lima/bin:$PATH
export FZF_DEFAULT_COMMAND="fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"
export STARSHIP_CONFIG=$devenv_tools_dir/config/starship.toml
alias ls='lsd'
alias cat='bat --paging=never'
alias which='whence -p'
alias for_all_files='fd --type f -x'
alias find_and_replace='fd --type f -x sd'
alias clang_format_files='fd -e h -e cpp -e c -x clang-format -i'

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

eval "$(zoxide init --cmd j zsh)"
eval "$(bat --completion zsh)"
eval "$(fzf --zsh)"
# eval "$(fd --gen-completions zsh)"
eval "$(starship init zsh)"
