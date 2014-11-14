-module(mnesia_client).
-include("records.hrl").
-export([init/0]).

init() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    create_tables(),
    timer:sleep(100),
    create_counters(),
    ok.

create_tables() ->
    create_table(sdata_json, sdata_json),
    create_table(counters, counter).

create_table(Table, Record_name) ->
    mnesia:create_table(Table, [{record_name, Record_name}, {type, set}, {attributes, record_fields(Record_name)}]).

% way around to pass variable to record_info
record_fields(sdata_json) -> record_info(fields, sdata_json);
record_fields(counters)   -> record_info(fields, counters).

create_counters() ->
    mnesia:dirty_update_counter(counters, some_counter, 0).
