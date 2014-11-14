-module(echo_handler).

-export([init/2]).

init(Req, Opts) ->
    Method = cowboy_req:method(Req),
    #{ids := IdsStr} = cowboy_req:match_qs([ids], Req),
    JsonResp = json_array(split_ids(IdsStr)),
    Req2 = echo(Method, JsonResp, Req),
    {ok, Req2, Opts}.

split_ids(undefined) -> ["-"];
split_ids(IdsStr) -> binary:split(IdsStr, <<",">>, [global]).

json_array(Vals) ->
    Joined = lists:foldr(fun (A, B) ->
        if
          bit_size(B) > 0 -> <<A/binary, <<", ">>/binary, B/binary>>;
          true -> A
        end
      end, <<>>, Vals),
    <<"[", Joined/binary, "]">>.

echo(<<"GET">>, Resp, Req) ->
    cowboy_req:reply(200, [
       {<<"content-type">>, <<"text/plain; charset=utf-8">>}
    ], Resp, Req);
echo(_, _, Req) ->
    %% Method not allowed.
    cowboy_req:reply(405, Req).