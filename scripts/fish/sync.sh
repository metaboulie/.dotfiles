#!/opt/homebrew/bin/fish
# automatically z to different workspaces, commit and push daily updates

function git_daily_update
    z $argv[1]; or exit
    git add .
    git commit -m "update: $(date "+%d/%m/%y")"
    git push; or exit
    z -
end

git_daily_update ~/deepBoredom
git_daily_update ~/metaboulie
git_daily_update ~
