devenv_tools_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
! [[ -f $devenv_tools_dir/devenv_tools.bash ]] && return

PATH=$devenv_tools_dir/bin:$PATH
export FZF_DEFAULT_COMMAND="fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"
export STARSHIP_CONFIG=$devenv_tools_dir/config/starship.toml
export LS_COLORS="$(vivid generate one-dark)"
alias ls='lsd'
export EDITOR=nvim
alias cat='bat --paging=never'
eval "$(fzf --bash)"
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

[[ -v devenv_tools_proxy ]] && \
  export HTTP_PROXY=$devenv_tools_proxy && \
  export HTTPS_PROXY=$devenv_tools_proxy && \
  export http_proxy=$devenv_tools_proxy && \
  export https_proxy=$devenv_tools_proxy

source $devenv_tools_dir/bin/autocomplete/bat.bash
source $devenv_tools_dir/bin/autocomplete/fd.bash
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
eval "$(starship init bash)"
