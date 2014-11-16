%% просто выдает RqPM по запросу /rqpm

-module(frontier_rqpm_handler).
-include("records.hrl").

-export([init/2]).
-export([terminate/3]).

init(Req, State) ->
    [#counter{value=Req_count}] = mnesia:dirty_read(counters, req_last_count),
    Respond = integer_to_binary(Req_count),
    Req2 = cowboy_req:reply(200, [{<<"Content-Type">>, <<"text/html">>}, {<<"connection">>, <<"close">>}], Respond, Req), 
    {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
    ok.