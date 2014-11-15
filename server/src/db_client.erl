-module(db_client).
-export([init/0]).
-export([count_sdata/0]).
-export([select_sdata/2]).
-include("records.hrl").

init() ->
    Credentials = frontier_config:db_credentials(),
    DB_pool_config = lists:concat([[frontier_pool, 4], Credentials]),
    apply(emysql, add_pool, DB_pool_config),
    prepare_queries(),
    ok.

prepare_queries() ->
    emysql:prepare(select_sdata, <<"SELECT id, name, kind, value FROM sdata LIMIT ?, ?;">>),
    emysql:prepare(count_sdata, <<"SELECT COUNT(*) FROM sdata;">>).

execute(Query, Args) ->
    emysql:execute(frontier_pool, Query, Args).

execute(Query) ->
    execute(Query, []).

count_sdata() ->
    Exec_res = execute(count_sdata),
    [[Res]] = Exec_res#result_packet.rows,
    Res.

select_sdata(Offset, Limit) ->
    execute(select_sdata, [Offset, Limit]).
