-module(map_reduce).

-export([start/1]).
-export([reduce/2, map/2]).
-export([loop_map/2,loop_reduce/3,start/0]).


start() ->
	start(["data1.txt","data2.txt","data3.txt","data4.txt","data5.txt"]).

start(Files) ->
    %% BEGIN
    Live_files = lists:filter(fun filelib:is_file/1, Files),
    io:format("find files: ~p~n",[Live_files]),

    PidR = spawn(?MODULE,loop_reduce,[self(),length(Live_files),#{}]),

    [spawn(?MODULE,loop_map,[PidR,F]) || F <- Live_files ],
	

    receive
    	{ok,Replay} -> Replay
    after 10000 -> no_replay
    end. 




loop_map(Pid,File) ->
	Pid ! {ok, map([],File)}.
	
loop_reduce(Pid,Num,Map) ->
	%Pid ! {loop_reduce,Pid,Num,Map},
	receive
		{ok,MapN} when Num == 1 -> 
			Pid ! {ok,reduce(MapN,Map)};
		{ok,MapN} ->
			loop_reduce(Pid, Num - 1, reduce(MapN,Map));
		_Any -> {reduce_error,_Any}	
	after 10000 -> {reduce_error, Num}		
	end.	


    %% END
    

%%open_file(FName) ->
%	case file:open(FName,[read]) of 
%	   {ok,IoDev} -> myread(IoDev), file:close(IoDev);
%	   {error,Reason}   -> Reason
%	end.   


reduce(MapN,Map) ->
	%maps:put("k"++io_lib:print(maps:size(Map) + 1),true,Map).
	 maps:fold(fun(K,V,Acc) -> maps:put(K,maps:get(K,Acc,0) + V,Acc) end,
	 	Map, MapN).



map(M,File_name) -> 	
	{_,Bin} = file:read_file(File_name), 
	Str = unicode:characters_to_list(Bin),
	L = string:tokens(Str," \r\n"),    
	lists:foldl(fun(E,Acc) -> maps:put(E,maps:get(E,Acc,0) + 1,Acc) end,
				#{},L).

