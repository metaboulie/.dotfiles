fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.ghcup/bin
fish_add_path $HOME/opt/bin

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx HATCH_CONFIG ~/.config/hatch.toml
set -gx PATH $HOME/.cargo/bin $PATH

function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

zoxide init fish | source
fzf --fish | source

alias ls 'eza --all --header --icons --git --git-ignore --tree --long --git-repos-no-status --binary --total-size'
alias lsa 'eza --all --header --icons --git --tree --long --git-repos-no-status --binary --total-size'
alias lss 'eza'
alias lsss 'eza -R -l -L 2'
alias lsbin 'eza ~/opt/bin -l --no-permissions --no-user -U --no-filesize'

alias bt "btop -t -lc"

alias c 'clear'
alias a "open -a 'Arc'"
alias credit 'z ~/metaboulie; v credits.txt'
alias clean 'brew autoremove; brew cleanup --prune=all'

alias u 'brew upgrade; rustup update; uv tool upgrade --all'

alias nf 'nvim ~/.config/fish/config.fish'
alias sf 'source ~/.config/fish/config.fish'

alias nn 'z ~/.config/nvim/; nvim .'
alias v 'nvim'
alias vl 'nvim ~/.local/state/nvim/lsp.log'
alias nc 'z ~/.config; nvim .'
alias n 'z ~/metaboulie; nvim todo.norg'

alias bi 'brew info'
alias bh 'brew home'
alias bl 'brew list'
alias bu 'brew uses --recursive --installed'

alias gs 'git switch'
alias gsm 'git switch main'
alias gc 'git clone --depth=1'
alias gf 'git fetch --prune'
alias gm 'git merge --no-ff'
alias gbe 'git branch --edit-description'

alias ghd "gh release download --clobber --dir ~/opt"

alias me 'uv run marimo edit --no-token'

alias ue 'uv pip install -e .'

alias rc 'ruff check'
alias rf 'ruff format'
alias r 'ruff format; ruff check'

function help -d 'print help message'
  # Execute command in a new fish process to ensure fish builtins work correctly
  # fish -c evaluates the following string as fish code in a new process
  command fish -c "$argv --help" 2>&1 | bat -l help -p
  or command fish -c "$argv -h" 2>&1 | bat -l help -p
end

function df -d 'show changes lines for all files in pwd'
  fd . --type file | xargs bat --diff 
end

set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"

function y -d 'open yazi'
  set tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"
  if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end

function hg -d 'prettier regex search'
  command hgrep --no-grid --printer bat -S "$argv" 
end

function check -d 'print credential info in cwd'
  command hgrep --no-grid --printer bat -S "(access_token|password|api_key)" | less -R
end

function gi
    echo '*' > .gitignore
    echo '!.gitignore' >> .gitignore
    eza -f | awk '{print "!" $0}' >> .gitignore
    bat .gitignore
end
