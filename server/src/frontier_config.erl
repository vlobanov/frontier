-module(frontier_config).
-export([server_port/0]).
-export([server_tcp_pool_size/0]).

server_port() ->
    {ok,[[Port_str]]} = init:get_argument(port),
    list_to_integer(Port_str).

server_tcp_pool_size() ->
    {ok, [Info]} = file:consult("./frontier.config"),
    {tcp_pool, Port} = lists:keyfind(tcp_pool, 1, Info),
    Port.
