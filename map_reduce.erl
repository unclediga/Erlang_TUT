-module(map_reduce).

-export([start/1]).
-export([reduce/2, map/2, loop/1]).


start(Files) ->
    %% BEGIN
    Live_files = lists:filter(fun filelib:is_file/1, Files),
    spawn(?MODULE,loop,[{self(),"data1.txt"}]),
    receive
    	{ok,Replay} -> Replay;
    	_Any -> {error}
    after 500 -> no_replay
    end. 


    %% END
    

%%open_file(FName) ->
%	case file:open(FName,[read]) of 
%	   {ok,IoDev} -> myread(IoDev), file:close(IoDev);
%	   {error,Reason}   -> Reason
%	end.   


reduce(P1,P2)	-> underconstr.

map(P1,File_list)	-> 
	lists:map(fun map/1,File_list).

map(File_name) -> 	
	{_,Bin} = file:read_file(File_name), 
	Str = unicode:characters_to_list(Bin),
	L = string:tokens(Str," \r\n"),    
	lists:foldl(fun(E,Acc) -> maps:put(E,maps:get(E,Acc,0) + 1,Acc) end,
				#{},L).

loop(State) ->
    io:format("spawn: State is ~p~n",[State]), 
	{ParentPid,File_name} = State,
	io:format("spawn: File name is ~s~n",[File_name]),
	ParentPid ! {ok,File_name}.
%% {_,Bin} = file:read_file("data1.txt"). 
%% unicode:characters_to_list(Bin)
%% string:tokens(Str," \r\n").    
