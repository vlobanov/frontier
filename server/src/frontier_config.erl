-module(frontier_config).
-export([server_port/0]).
-export([server_tcp_pool_size/0]).
-export([db_credentials/0]).

server_port() ->
    {ok,[[Port_str]]} = init:get_argument(port),
    list_to_integer(Port_str).

server_tcp_pool_size() ->
    read_config_key(tcp_pool).

db_credentials() ->
    read_config_key(db_credentials).

read_config_key(Key) ->
    {ok, [Info]} = file:consult("./frontier.config"),
    {Key, Val} = lists:keyfind(Key, 1, Info),
    Val.
