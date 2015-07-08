-module(testpid).

-export([send/3,loop/3]).


send(Pid,X,Y) ->
	spawn(?MODULE,loop,[Pid,X,Y]).

loop(Pid,X,Y) -> 
	receive
		{show} ->  
			io:format("Hello! X*Y=~p~n",[X*Y]),
			Pid ! (X * Y),
			loop(Pid,X,Y);
		{exit} -> Pid ! "I am out!",
				  exit
	end.
 
				