-record(result_packet, {seq_num, field_list, rows, extra}).
-record(sdata_json,    {id, json}).
-record(counter, {name, value}).

-ifdef(debug).
    -define(DEBUG(Str, Params), io:format("{~p:~p} " ++ Str ++ "\n", [?LINE, ?MODULE] ++ Params)).
-else.
    -define(DEBUG(Str,Params), true).
-endif.
