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
-export([refresh_cache/0]).
-export([read_sdata/1]).

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
    ?TABLE = ets:new(?TABLE, [set, protected, named_table, {read_concurrency, true}]),
    refresh_cache(),
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
    utils:measure_time(frontier_cache_server, refresh_cache, []),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%% @private
terminate(_Reason, _State) ->
    ok.

%% @private
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

read_sdata(Key) ->
    ets:lookup_element(?TABLE, Key, 2).

write_to_mnesia(Row) ->
    [Id | _] = Row,
    Json_data = utils:sdata_record_to_json(Row),
    Id_bin = integer_to_binary(Id),
    ets:insert(?TABLE, {Id_bin, Json_data}).
    % mnesia:dirty_write(sdata_json, Sdata_record).

refresh_records(Total_count, Offset, _) when Offset >= Total_count ->
    ok;
refresh_records(Total_count, Offset, Chunk_size) ->
    Res = db_client:select_sdata(Offset, Chunk_size),
    Rows = Res#result_packet.rows,
    lists:foreach(fun write_to_mnesia/1, Rows),
    refresh_records(Total_count, Offset + Chunk_size, Chunk_size).


refresh_cache() ->
    Total_count = db_client:count_sdata(),
    Chunk_size = 6000,
    refresh_records(Total_count, 0, Chunk_size).
