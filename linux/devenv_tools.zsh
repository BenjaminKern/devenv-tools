devenv_tools_dir="$(cd "$(dirname "${(%):-%N}")" &> /dev/null && pwd)"
if [[ ! -f "$devenv_tools_dir/devenv_tools.zsh" ]]; then
    return
fi

setopt nobeep autocd
export CLICOLOR=1
autoload -Uz compinit
fpath=($devenv_tools_dir/bin/autocomplete $devenv_tools_dir/bin/complete $devenv_tools_dir/bin/completions $fpath)
compinit
zstyle ':completion:ls:*' menu yes select
zstyle ':completion:*:default' list-colors \
    "di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

PATH=$devenv_tools_dir/bin:$devenv_tools_dir/cpptools/debugAdapters/bin:$devenv_tools_dir/lima/bin:$PATH
export FZF_DEFAULT_COMMAND="fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"
export STARSHIP_CONFIG=$devenv_tools_dir/config/starship.toml
alias ls='lsd'
export EDITOR=nvim
alias cat='bat --paging=never'
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}
ff() {
    fzf \
      --ansi --no-sort --reverse --tiebreak=index \
      --preview "bat --theme OneHalfDark --style=numbers --color=always --line-range :500 {}" \
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
gco() {
  is_in_git_repo || return

  local branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  target=$(
    echo "$branches" |
    fzf --reverse --no-multi -n 2 \
        --ansi --preview="git diff HEAD..{2} | delta --line-numbers --syntax-theme=OneHalfDark; " \
        --bind "alt-j:preview-down,alt-k:preview-up,q:abort" \
        --preview-window=right:60%) || return
  git checkout $(echo "$target" | cut -f 2)
}

rfv() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            nvim {1} +{2}     # No selection. Open the current line in Vim.
          else
            nvim +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat --theme OneHalfDark --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)

alias for_all_files='fd --type f -x'
alias find_and_replace='fd --type f -x sd'
alias clang_format_files='fd -e h -e cpp -e c -x clang-format -i'

eval "$(zoxide init --cmd j zsh)"
eval "$(starship init zsh)"
