#!/opt/homebrew/bin/fish
# ls bins

function lsbin
    eza $argv[1] -l --no-permissions --no-user -U --no-filesize
end

lsbin ~/opt/bin
lsbin ~/dev/bin
lsbin ~/scripts/bin
