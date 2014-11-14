-module(utils).

-export([split_ids/1]).
-export([json_array/1]).

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
