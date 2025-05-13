#!/opt/homebrew/bin/fish
# automatically z to different workspaces, commit and push daily updates

function git_sync
    z $argv[1]; or exit
    set_color bryellow 
    echo "syncing $argv[1]"
    set_color normal
    git add .
    git commit -m "update: $(date "+%d/%m/%y")"
    git push  > /dev/null 2>&1 ; or exit
    set_color bryellow 
    echo "syncing finished"
    z -
end

git_sync ~/deepBoredom
git_sync ~/metaboulie
git_sync ~
