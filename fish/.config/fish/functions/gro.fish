# gro — fetch origin, then rebase the current branch onto its origin counterpart.
function gro --description 'git fetch origin && git rebase onto origin/<current-branch>'
    set -l branch (git symbolic-ref --quiet --short HEAD)
    or begin
        echo "gro: not on a branch (detached HEAD)" >&2
        return 1
    end
    git fetch origin; and git rebase origin/$branch
end
