#!/opt/homebrew/bin/fish
# ls bins

function lsbin
    echo "ls bins in $argv[1]"
    eza $argv[1] -l --no-permissions --no-user -U --no-filesize
end

lsbin ~/opt/bin
lsbin ~/scripts/bin
