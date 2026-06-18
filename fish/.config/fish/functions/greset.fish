# greset — fetch origin, then HARD-reset the current branch to its origin
# counterpart. Destructive: discards local commits and uncommitted changes on
# this branch that aren't on origin/<branch>.
function greset --description 'git fetch origin && git reset --hard origin/<current-branch>'
    set -l branch (git symbolic-ref --quiet --short HEAD)
    or begin
        echo "greset: not on a branch (detached HEAD)" >&2
        return 1
    end
    git fetch origin; and git reset --hard origin/$branch
end
