# ~/.config/fish/conf.d/marks.fish
# A fish replacement for prwd (eriknomitch/prwd): named directory bookmarks plus a
# "default" directory your shell jumps to on open.
#
# Note on the "nicer alternative": frecency-style jumping ("take me to that dir I
# use a lot") is already handled by zoxide — just type `z partialname`. This file
# is for *explicit, deliberate* bookmarks (sw/gw/lw muscle memory) and a default dir.
#
# Commands:
#   mark [name]      bookmark the current dir   (default name: "default")  [alias: sw]
#   jump [name]      cd to a bookmark           (default name: "default")  [alias: gw]
#   marks            list all bookmarks                                    [alias: lw]
#   unmark <name>    remove a bookmark
#   setdef           shortcut for `mark default`
# Toggle the open-in-default behaviour with:  set -U marks_autocd 0

set -q marks_file; or set -gx marks_file "$HOME/.local/share/fish-marks"
set -q marks_autocd; or set -U marks_autocd 1

function _marks_ensure
    test -f "$marks_file"; and return 0
    mkdir -p (dirname "$marks_file"); and touch "$marks_file"
end

function _marks_get --argument-names name
    _marks_ensure
    while read -l line
        set -l rest (string split -m1 ' ' -- $line)
        if test (count $rest) -ge 2; and test "$rest[1]" = "$name"
            echo $rest[2]
            return 0
        end
    end <"$marks_file"
    return 1
end

function _marks_names
    _marks_ensure
    while read -l line
        set -l rest (string split -m1 ' ' -- $line)
        test -n "$rest[1]"; and echo $rest[1]
    end <"$marks_file"
end

function mark --argument-names name --description "Bookmark the current directory (default: 'default')"
    test -z "$name"; and set name default
    if string match -q '* *' -- $name
        echo "mark: name can't contain spaces" >&2
        return 1
    end
    _marks_ensure
    set -l tmp (mktemp)
    while read -l line
        set -l rest (string split -m1 ' ' -- $line)
        test "$rest[1]" = "$name"; or echo $line >>$tmp
    end <"$marks_file"
    echo "$name $PWD" >>$tmp
    mv $tmp "$marks_file"
    echo "marked '$name' → $PWD"
end

function jump --argument-names name --description "cd to a bookmark (default: 'default')"
    test -z "$name"; and set name default
    set -l dir (_marks_get $name)
    if test -z "$dir"
        echo "jump: no bookmark '$name' (see `marks`)" >&2
        return 1
    end
    if not test -d "$dir"
        echo "jump: '$name' → $dir no longer exists" >&2
        return 1
    end
    cd "$dir"
end

function marks --description "List directory bookmarks"
    _marks_ensure
    if not test -s "$marks_file"
        echo "no bookmarks yet — run `mark <name>` in a directory"
        return 0
    end
    sort "$marks_file" | while read -l line
        set -l rest (string split -m1 ' ' -- $line)
        printf "  %-14s %s\n" $rest[1] $rest[2]
    end
end

function unmark --argument-names name --description "Remove a bookmark"
    if test -z "$name"
        echo "usage: unmark <name>" >&2
        return 1
    end
    _marks_ensure
    set -l tmp (mktemp)
    set -l found 0
    while read -l line
        set -l rest (string split -m1 ' ' -- $line)
        if test "$rest[1]" = "$name"
            set found 1
        else
            echo $line >>$tmp
        end
    end <"$marks_file"
    mv $tmp "$marks_file"
    if test $found -eq 1
        echo "removed '$name'"
    else
        echo "no bookmark '$name'" >&2
        return 1
    end
end

function setdef --description "Set the current directory as the 'default' bookmark"
    mark default
end

# prwd compatibility aliases (muscle memory)
function sw --description "prwd compat → mark"
    mark $argv
end
function gw --description "prwd compat → jump"
    jump $argv
end
function lw --description "prwd compat → marks"
    marks $argv
end

# Tab-complete bookmark names
complete -c jump -f -a "(_marks_names)"
complete -c unmark -f -a "(_marks_names)"
complete -c gw -f -a "(_marks_names)"

# Open a fresh shell in the "default" bookmark. Only fires when the shell starts at
# $HOME, so terminals you launch inside a project (or WM splits) are left untouched.
if status is-interactive; and test "$marks_autocd" = 1
    if test "$PWD" = "$HOME"
        set -l def (_marks_get default)
        if test -n "$def"; and test -d "$def"
            cd "$def"
        end
    end
end
