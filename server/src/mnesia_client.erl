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
    create_table(counters, counter).

create_table(Table, Record_name) ->
    mnesia:create_table(Table, [{record_name, Record_name}, {type, set}, {attributes, record_fields(Record_name)}]).

% way around to pass variable to record_info
record_fields(sdata_json) -> record_info(fields, sdata_json);
record_fields(counter)    -> record_info(fields, counter).

create_counters() ->
    mnesia:dirty_update_counter(counters, req_curr_count, 0),
    mnesia:dirty_update_counter(counters, req_last_count, 0).