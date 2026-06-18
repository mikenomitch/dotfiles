# killport — kill whatever process is listening on a TCP port (e.g. killport 4000).
function killport --description 'Kill the process(es) on a TCP port (e.g. killport 4000)'
    if test (count $argv) -ne 1
        echo "usage: killport <port>" >&2
        return 2
    end
    set -l port $argv[1]
    set -l pids (lsof -ti tcp:$port)
    if test -z "$pids"
        echo "killport: nothing listening on port $port" >&2
        return 1
    end
    echo "killport: killing PID(s) on port $port: $pids"
    kill $pids
end
