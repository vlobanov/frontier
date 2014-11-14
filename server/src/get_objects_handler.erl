-module(get_objects_handler).

-export([init/2]).

init(Req, Opts) ->
    Method = cowboy_req:method(Req),
    #{ids := Echo} = cowboy_req:match_qs([ids], Req),
    Req2 = echo(Method, Echo, Req),
    {ok, Req2, Opts}.

echo(<<"GET">>, undefined, Req) ->
    cowboy_req:reply(400, [], <<"Missing ids parameter.">>, Req);
echo(<<"GET">>, Echo, Req) ->
    cowboy_req:reply(200, [
       {<<"content-type">>, <<"text/plain; charset=utf-8">>}
    ], Echo, Req);
echo(_, _, Req) ->
    %% Method not allowed.
    cowboy_req:reply(405, Req).