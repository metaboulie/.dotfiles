function fish_mode_prompt; end
function fish_prompt
    set dir_color cyan
    set branch_color green
    set status_color green
    set prompt_color brcyan

    set dir (set_color $dir_color; prompt_pwd; set_color normal)

    set branch ''
    set git_status ''
    if test -d .git; or test -n (git rev-parse --git-dir 2>/dev/null)
        set branch (set_color $branch_color; git symbolic-ref --short HEAD 2>/dev/null; set_color normal)
        set changes (git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        if test $changes -gt 0
            set git_status (set_color $status_color; echo "!$changes"; set_color normal)
        end
    end

    echo -n $dir
    if test -n "$branch"
        echo -n "$branch"
    end
    if test -n "$git_status"
        echo -n "$git_status"
    end
    echo

    set_color $prompt_color
    echo -n "( ._.) "
    set_color normal
end
