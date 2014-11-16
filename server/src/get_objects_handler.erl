-module(get_objects_handler).

-export([init/2]).

init(Req, Opts) ->
    Method = cowboy_req:method(Req),
    #{ids := Ids} = cowboy_req:match_qs([ids], Req),
    Ids_list = utils:split_ids(Ids),
    Response = fetch_sdata_json_array(Ids_list),
    Req2 = make_response_req(Method, Response, Req),
    frontier_rqpm_server:count_request(),
    {ok, Req2, Opts}.

fetch_sdata_json_array(Ids) ->
    Sdata_json_vals = lists:map(
        fun (Id) ->
            frontier_cache_server:read_sdata(Id)
        end,
        Ids),
    utils:json_array(Sdata_json_vals).

make_response_req(<<"GET">>, undefined, Req) ->
    cowboy_req:reply(400, [], <<"Missing ids parameter.">>, Req);
make_response_req(<<"GET">>, Echo, Req) ->
    cowboy_req:reply(200, [
       {<<"content-type">>, <<"text/plain; charset=utf-8">>}
    ], Echo, Req);
make_response_req(_, _, Req) ->
    %% Method not allowed.
    cowboy_req:reply(405, Req).