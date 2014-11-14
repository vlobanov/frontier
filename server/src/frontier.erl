-module(frontier).

%% API.
-export([start/0]).

%% API.
start() ->
    ok = application:start(crypto),
    ok = application:start(cowlib),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(emysql),
    ok = db_client:init(),
    ok = mnesia_client:init(),
    ok = application:start(frontier).
