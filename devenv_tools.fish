# Get the directory where this script is located
set -gx devenv_tools_dir (cd (dirname (status --current-filename)); and pwd)

# Check if devenv_tools.bash exists (you might want to rename this for Fish)
if not test -f $devenv_tools_dir/devenv_tools.bash
    exit
end

# Environment variables
set -gx EDITOR nvim
set -gx SHELL (which fish)

# Add to PATH
fish_add_path $devenv_tools_dir/bin

# FZF configuration
set -gx FZF_DEFAULT_COMMAND "fd --color never --type f --hidden --ignore-file $devenv_tools_dir/share/nvim/.fd-ignore"

# Aliases
alias ls='lsd'
alias cat='bat --paging=never'
alias for_all_files='fd --type f -x'
alias find_and_replace='fd --type f -x sd'
alias clang_format_files='fd -e h -e cpp -e c -x clang-format -i'

# Helper function to check if in git repo
function is_in_git_repo
    git rev-parse HEAD > /dev/null 2>&1
end

# Fuzzy file finder with preview
function ff
    fzf \
        --ansi --no-sort --reverse --tiebreak=index \
        --preview "bat --theme 1337 --style=numbers --color=always --line-range :500 {}" \
        --bind "alt-j:preview-down,alt-k:preview-up,q:abort" \
        --preview-window=right:60%
end

# Git log viewer with fzf
function gv
    if not is_in_git_repo
        return
    end

    set -l filter
    if test (count $argv) -gt 0; and test -f $argv[1]
        set filter "-- $argv"
    end

    git lg $argv | \
        fzf \
            --ansi --no-sort --reverse --tiebreak=index \
            --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always --format=fuller \$1 $filter | delta --line-numbers --syntax-theme=OneHalfDark; }; f {}" \
            --bind "alt-j:preview-down,alt-k:preview-up,q:abort" \
            --preview-window=right:60%
end

# Fuzzy find and edit with ripgrep
function ffe
    set -l query "$argv"
    if test -z "$query"
        set query ""
    end
    
    rg --color=always --line-number --no-heading --smart-case $query |
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --color=always {1} --highlight-line {2}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind 'enter:become(nvim {1}:{2})'
end

# History configuration
# Fish handles history differently - these are the equivalent settings
set -g fish_history_max_size 500000
# Fish automatically appends to history and removes duplicates

# Initialize tools
# Using eval for compatibility with Fish's redirection handling
eval (zoxide init --cmd j fish)
eval (fzf --fish 2>/dev/null)
eval (fd --gen-completions fish 2>/dev/null)
eval (watchexec --completions fish 2>/dev/null)
eval (oh-my-posh init fish --config $devenv_tools_dir/config/xyz.omp.json)
