%% @private
-module(frontier_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
       {'_', [
         {"/getObjects", get_objects_handler, []},
         {"/echo", echo_handler, []},
         {"/rqpm", frontier_rqpm_handler, []}
       ]}
    ]),
    {ok, _} = cowboy:start_http(http, 
        frontier_config:server_tcp_pool_size(),
        [{port, frontier_config:server_port()}], 
        [{env, [{dispatch, Dispatch}, {max_connections, infinity}]}
    ]),
    frontier_sup:start_link().

stop(_State) ->
    ok.