-module(measurement).
-compile([export_all]).


measure() ->
    Data = <<"I AM TESTING DATA...">>,
    io:format("Int Key:~n", []),
    io:format("Times:\t\tP-Dict:\t\tETS\t\t:~n", []),

    {Time1, _Val}= timer:tc(fun pdict_write_intkey/2, [1000, Data]),
    io:format("1000\t\t~pus\t\t", [Time1]),

    {Time2, _Val}= timer:tc(fun ets_write_intkey/3, [1000, Data, start]),
    io:format("~pus\t\t~n", [Time2]).

pdict_write_intkey(0, _Data) ->
    ok;
pdict_write_intkey(N, Data) ->
    put(67886, Data),
    pdict_write_intkey(N - 1, Data).

ets_write_intkey(N, Data, start) ->
    ets:new(test_ets, [public, named_table]),
    ets:insert(test_ets, {67886, Data}),
    ets_write_intkey(N, Data).

ets_write_intkey(0, _Data) ->
    ok;
ets_write_intkey(N, Data) ->
    ets:update_element(test_ets, 67886, {2, Data}),
    ets_write_intkey(N-1, Data).

