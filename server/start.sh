#!/bin/sh
if [ $1 ]
then
	ALLARGS=$*
	ulimit -n 60000
	mkdir -p ./logs/$1
	rm -rf /tmp/frontier_$1
	mkdir -p /tmp/frontier_$1
    ulimit -a
	erl +Q 64000 +P 128000 -port $ALLARGS -sname frontier_$1@localhost -mnesia dir "'/tmp/frontier_$1'" -pa ebin deps/*/ebin -s frontier \
		-eval "io:format(\"frontier caching started on port $1~n\")."
else  
	echo "You should specify port\n"
fi
