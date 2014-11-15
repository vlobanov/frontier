
-module(utils).

-include_lib("eunit/include/eunit.hrl").
-include("records.hrl").

-export([split_ids/1]).
-export([json_array/1]).
-export([sdata_record_to_json/1]).
-export([measure_time/3]).

measure_time(Module, Func, Args) ->
    {T, Res} = timer:tc(Module, Func, Args),
    ?DEBUG("--~p:~p (~p)  -> ~p\n", [Module, Func, Args, T / 1000]),
    Res.

split_ids(undefined) -> [<<"-">>];
split_ids(IdsStr) -> binary:split(IdsStr, <<",">>, [global]).

json_array(Vals) ->
    Joined = lists:foldr(fun (A, B) ->
        if
          bit_size(B) > 0 -> <<A/binary, <<", ">>/binary, B/binary>>;
          true -> A
        end
      end, <<>>, Vals),
    <<"[", Joined/binary, "]">>.

convert_val(undefined) ->
    <<"null">>;
convert_val(Val) when is_integer(Val) -> 
    integer_to_binary(Val);
convert_val(Val) when is_float(Val) -> 
    float_to_binary(Val, [{decimals, 2}]);
convert_val(Val) ->
    <<<<"\"">>/binary, Val/binary, <<"\"">>/binary>>.

sdata_record_to_json([Id, Name, Kind, Value]) ->
    Id_val =   convert_val(Id),
    Name_val = convert_val(Name),
    Kind_val = convert_val(Kind),
    Value_val = convert_val(Value),
    <<
        <<"{">>/binary,
            <<"id: ">>/binary,    Id_val/binary, <<", ">>/binary,
            <<"name: ">>/binary,  Name_val/binary, <<", ">>/binary,
            <<"kind: ">>/binary,  Kind_val/binary, <<", ">>/binary,
            <<"value: ">>/binary, Value_val/binary,
        <<"}">>/binary
    >>.

sdata_record_to_json_test() ->
    Val = sdata_record_to_json([5, <<"hello, world">>, 42, 1999.99]),
    io:format("~p", [Val]),
    Val = <<"{id: 5, name: \"hello, world\", kind: 42, value: 1999.99}">>.

sdata_record_to_json_with_nuls_test() ->
    Val = sdata_record_to_json([5, undefined, undefined, 1999.99]),
    io:format("~p", [Val]),
    Val = <<"{id: 5, name: null, kind: null, value: 1999.99}">>.