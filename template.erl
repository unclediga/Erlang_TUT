-module(template).

-export([parse/2]).

parse(Str, Data) when is_binary(Str) ->
    %% BEGIN
    iolist_to_binary(parse2(Str,Data)).

parse2(Str,Data) ->
    case binary:split(Str,<<"{{">>) of
    	[L|[]] -> Str;
    	[H | [T | _]] -> 
    		[K|[T2 | _]] = binary:split(T,<<"}}">>),
    		case maps:get(K,Data) of
    			KD when is_integer(KD) -> 
    				[ H | [ unicode:characters_to_binary(io_lib:print(KD)) | [parse(T2,Data)]]];
    			KD when is_binary(KD) -> 
    				[ H | [ KD | [parse(T2,Data)]]];
    			KD -> 	
    			    [ H | [ unicode:characters_to_binary(KD) | [parse(T2,Data)]]]

   			end
   	end.

    %% END


Parts = binary:split(Str, [<<"{{">>], [global]),
    Parts2 =
        lists:map(fun(Part) ->
                          case binary:split(Part, [<<"}}">>]) of
                              [PartWithNoParam] -> PartWithNoParam;
                              [Param | Rest] ->
                                  case maps:find(Param, Data) of
                                      error -> Rest;
                                      {ok, Value} when is_binary(Value) orelse is_list(Value) ->
                                          [Value, Rest];
                                      {ok, Value} when is_integer(Value) ->
                                          [integer_to_binary(Value), Rest]
                                  end
                          end
                  end, Parts),
    unicode:characters_to_binary(Parts2).    


