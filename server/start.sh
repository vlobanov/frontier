#!/bin/sh
if [ $1 ]
then
	ALLARGS=$*
	ulimit -n 10000
	mkdir -p ./logs/$1
	rm -rf /tmp/frontier_$1
	mkdir -p /tmp/frontier_$1
	erl -port $ALLARGS -sname admy_ad_$1@localhost -mnesia dir "'/tmp/frontier_$1'" -pa ebin deps/*/ebin -s frontier \
		-eval "io:format(\"frontier caching started on port $1~n\")."
else  
	echo "You should specify port\n"
fi
