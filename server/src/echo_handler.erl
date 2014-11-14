-module(echo_handler).

-export([init/2]).

init(Req, Opts) ->
    Method = cowboy_req:method(Req),
    #{ids := IdsStr} = cowboy_req:match_qs([ids], Req),
    JsonResp = utils:json_array(utils:split_ids(IdsStr)),
    Req2 = echo(Method, JsonResp, Req),
    io:format("."),
    {ok, Req2, Opts}.

echo(<<"GET">>, Resp, Req) ->
    cowboy_req:reply(200, [
       {<<"content-type">>, <<"text/plain; charset=utf-8">>},
       {<<"connection">>, <<"close">>}
    ], Resp, Req);
echo(_, _, Req) ->
    %% Method not allowed.
    cowboy_req:reply(405, Req).
