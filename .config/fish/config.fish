fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.ghcup/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/dev/bin
fish_add_path $HOME/opt/bin
fish_add_path $HOME/scripts/bin

zoxide init fish | source
fzf --fish | source

set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"

set -gx HATCH_CONFIG ~/.config/python/.hatch.toml
set -gx TAPLO_CONFIG ~/.config/taplo.toml

### ALIASES 
## ls
# general ls
alias ls 'eza --all --no-permissions --no-user --header --icons --git --git-ignore --tree --long --git-repos-no-status --binary --total-size'
# ls cwd
alias lss 'eza'
# ls recursively
alias lsss 'eza -R -l -L 2'
# ls bin in opt
alias lsopt 'eza ~/opt/bin -l --no-permissions --no-user -U --no-filesize'
# ls bin in dev
alias lsdev 'eza ~/dev/bin -l --no-permissions --no-user -U --no-filesize'
# ls bin in scripts
alias lsscripts 'eza ~/scripts/bin -l --no-permissions --no-user -U --no-filesize'

## start software
# btop
alias bt "btop -t -lc"
# yazi
function y -d 'open yazi'
  set tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"
  if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end

## system util
# clear buffer
alias c 'clear'

## pkg managers
# clean
alias clean 'brew autoremove; brew cleanup --prune=all'
# update
alias u 'brew upgrade; rustup update;'

## config
# open config.fish
alias nf 'nvim ~/.config/fish/config.fish'
# source config.fish
alias sf 'source ~/.config/fish/config.fish'
# cd and open nvim config
alias nn 'cd ~/.config/nvim/; nvim .'
# cd and open config
alias nc 'cd ~/.config; nvim .'

## nvim
# open nvim
alias v 'nvim'
# open lsp log
alias vl 'nvim ~/.local/state/nvim/lsp.log'
# cd and open neorg
alias n 'cd ~/metaboulie; nvim todo.norg'

## brew
# info
alias bi 'brew info'
# home
alias bh 'brew home'
# uses
alias bu 'brew uses --recursive --installed'

## git
# clone
alias gc 'git clone --depth=1'
# log
alias gl 'git log --graph --decorate --oneline | bat --language=gitlog'
# download github release
alias ghd "gh release download --clobber --dir ~/opt"

## python
# marimo edit
alias me 'uvx marimo edit --no-token --sandbox'
# marimo run
alias mr 'uvx marimo run --sandbox'
# uv dev install
alias ue 'uv pip install -e .'
# ruff check
alias rc 'ruff check'
# ruff format
alias rf 'ruff format'
# ruff check & format
alias r 'ruff format; ruff check'

## search
# regex search
function hg -d 'prettier regex search'
  command hgrep --no-grid --printer bat -S "$argv" 
end

## pretty print
# help message
function help -d 'print help message'
  # Execute command in a new fish process to ensure fish builtins work correctly
  # fish -c evaluates the following string as fish code in a new process
  command fish -c "$argv --help" 2>&1 | bat -l help -p
  or command fish -c "$argv -h" 2>&1 | bat -l help -p
end
# credential info
function check -d 'print credential info in cwd'
  command hgrep --no-grid --printer bat -S "(access_token|password|api_key)" | less -R
end

## initilize
# .gitignore
function gi -d 'initialize .gitignore in incremental style'
  echo '*' > .gitignore
  echo '!.gitignore' >> .gitignore
  eza -f | awk '{print "!" $0}' >> .gitignore
  bat .gitignore
end
# python
function pi -d 'initilize a python project' -a name
  hatch new $name
  cd $name
  git init
  cp ~/.config/python/*.toml ./
  cp -R ~/.config/.github/* ./.github/
  gi
  printf "!.github/\n!.github/**\n!src/\n!src/$name/\n!src/$name/**\n!tests/\n!tests/**" >> .gitignore
  touch todo.norg
end
