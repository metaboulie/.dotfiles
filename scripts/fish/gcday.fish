#!/usr/bin/env fish
# automatically z to different workspaces, commit and push daily updates

function git_daily_update
    set dirname $argv[1]
    z $dirname
    set curdate (date "+%d/%m/%y")
    git add . && git commit -m "update: $curdate" && git push
    z -
end

git_daily_update ~/deepBoredom
git_daily_update ~/metaboulie
git_daily_update ~
