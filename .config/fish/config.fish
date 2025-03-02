fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/bin
fish_add_path /Users/chanhuizhihou/.local/bin
fish_add_path $HOME/.ghcup/bin

# set default editor 
set -gx EDITOR nvim
set -gx VISUAL nvim

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# rust
set -gx PATH $HOME/.cargo/bin $PATH

# pnpm
set -gx PNPM_HOME "/Users/chanhuizhihou/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# node
function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

# zoxide
zoxide init fish | source
alias cd 'z'

# fzf
fzf --fish | source

# eza
alias ls 'eza --all --header --icons --git --git-ignore --tree --long --git-repos-no-status --binary --total-size'
alias lsa 'eza --all --header --icons --git --tree --long --git-repos-no-status --binary --total-size'
alias lss 'eza'
alias lsss 'eza -R -l -L 2'

# btop
alias bt "btop -t -lc"

# builtin
alias c 'clear'
alias a "open -a 'Arc'"
alias credit 'z ~/metaboulie; v credits.txt'

# lazygit
alias l 'lazygit'
alias s 'source .venv/bin/activate.fish'

# update package managers
alias u 'brew upgrade; rustup update; uv tool upgrade ruff marimo motheme; brew autoremove; brew cleanup'

# fish
alias nf 'nvim ~/.config/fish/config.fish'
alias vf 'nvim ~/.config/fish/config.fish'
alias ng 'nvim ~/.gitconfig'
alias sf 'source ~/.config/fish/config.fish'

# neovim
alias nn 'z ~/.config/nvim/; nvim .'
alias v 'nvim'

# brew
alias bi 'brew info'
alias bh 'brew home'
alias bl 'brew list'
alias bd 'brew doctor'
alias bc 'brew cleanup'

# git
alias gs 'git switch'
alias gsm 'git switch main'
alias gsd 'git switch develop'
alias gc 'git clone --depth=1'
alias gf 'git fetch --prune'
alias gm 'git merge --no-ff'
alias gb 'git branch'
alias gbd 'git branch -D'
alias gl 'git ls-remote'
alias gbe 'git branch --edit-description'

# marimo
alias me 'uv run marimo edit'
alias md 'uv run marimo -d edit --no-token --headless'

# uv
alias ue 'uv pip install -e .'


# ruff
alias rc 'ruff check'
alias rf 'ruff format'

# bat
function help -d 'print help message'
  # Execute command in a new fish process to ensure fish builtins work correctly
  # fish -c evaluates the following string as fish code in a new process
  command fish -c "$argv --help" 2>&1 | bat -l help -p
  or command fish -c "$argv -h" 2>&1 | bat -l help -p
end

function df -d 'show changes lines for all files in pwd'
  fd . --type file | xargs bat --diff 
end

# use bat as man's pager
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"

# yazi
function y -d 'open yazi'
  set tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"
  if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end

# hgrep
function hg -d 'prettier regex search'
  command hgrep --no-grid --printer bat -S "$argv" | less -R
end

function check -d 'print credential info in cwd'
  command hgrep --no-grid --printer bat -S "(access_token|password|api_key)" | less -R
end
