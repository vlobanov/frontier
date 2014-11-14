-module(frontier_cache_server).

-behaviour(gen_server).
-include("records.hrl").

-export([start_link/0]).
-export([stop/0]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-record(state, {
    tref = undefined  :: undefineds | timer:tref()
}).

-define(SERVER, ?MODULE).
-define(TABLE, ?MODULE).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    gen_server:call(?SERVER, stop).

%% @private
init([]) ->
    {ok, TRef} = timer:send_interval(5 * 1000, refresh_cache),
    State = #state{tref=TRef},
    io:format("Cache gen server started in ~p\n", [self()]),
    {ok, State}.

%% @private
handle_call(stop, _From, State=#state{tref=TRef}) ->
    {ok, cancel} = timer:cancel(TRef),
    {stop, normal, stopped, State};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

%% @private
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @private
handle_info(refresh_cache, State) ->
    refresh_cache(),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%% @private
terminate(_Reason, _State) ->
    ok.

%% @private
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOGIC %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

refresh_cache() ->
    ?DEBUG("Refreshing cache", []).

