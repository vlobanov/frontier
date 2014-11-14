%% @private
-module(frontier_sup).
-behaviour(supervisor).

%% API.
-export([start_link/0]).

%% supervisor.
-export([init/1]).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% supervisor.

worker_params(Name) ->
    {Name, {Name, start_link, []}, permanent, brutal_kill, worker, [Name]}.

init([]) ->
    Procs = [
        worker_params(frontier_cache_server)
    ],
    {ok, {{one_for_one, 10, 10}, Procs}}.