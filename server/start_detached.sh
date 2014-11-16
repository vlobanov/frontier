#!/bin/sh
if [ $1 ]
then
    ALLARGS=$*
    ulimit -n 60000
    mkdir -p ./logs/$1
    rm -rf /tmp/frontier_$1
    mkdir -p /tmp/frontier_$1
    rm -rf /tmp/erl_logs_$1
    mkdir -p /tmp/erl_logs_$1
    ulimit -a
    run_erl -daemon /tmp/erl_logs_$1/ ./logs/$1/ "erl +Q 64000 +P 128000 -port $ALLARGS -sname frontier_$1@localhost -mnesia dir \"'/tmp/frontier_$1'\" -pa ebin deps/*/ebin -s frontier"
else  
    echo "You should specify port\n"
fi

run_erl -daemon /tmp/erl_logs_8080/ ./logs/8080/ "erl +Q 64000 +P 128000 -port 8080 -sname frontier_$1@localhost -mnesia dir \"'/tmp/frontier_8080'\" -pa ebin deps/*/ebin -s frontier"
