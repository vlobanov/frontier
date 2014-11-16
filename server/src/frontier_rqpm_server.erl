%% сервер, раз в минуту сохраняющий RqPM в мнезию по ключу req_last_count

-module(frontier_rqpm_server).
-behaviour(gen_server).
-include("records.hrl").
%% API.
-export([start_link/0]).
-export([stop/0]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-export([count_request/0]).

-record(state, {
    tref = undefined  :: undefineds | timer:tref()
}).

-define(SERVER, ?MODULE).

%% API.

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% @private
stop() ->
    gen_server:call(?SERVER, stop).

%% gen_server.

%% @private
init([]) ->
    {ok, TRef} = timer:send_interval(60 * 1000, save_stats),
    State = #state{tref = TRef},
    io:format("Statistics server started in ~p\n", [self()]),
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
handle_info(save_stats, State) ->
    save_stats(),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%% @private
terminate(_Reason, _State) ->
    ok.

%% @private
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

count_request() ->
    mnesia:dirty_update_counter(counters, req_curr_count, 1).

save_stats() ->
    [#counter{value=Req_count}] = mnesia:dirty_read(counters, req_curr_count),
    ?DEBUG("RqPM = ~p", [Req_count]),
    mnesia:dirty_write(counters, #counter{name=req_last_count, value=Req_count}),
    mnesia:dirty_update_counter(counters, req_curr_count, -1 * Req_count).
