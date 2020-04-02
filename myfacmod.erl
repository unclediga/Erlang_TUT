-module(myfacmod).
-export([fac/1,remote_call/2,server/0,facloop/0,stop/1]).

fac(0) -> 1;
fac(N) -> N * fac(N - 1).



remote_call(Message, Node)	-> 
	{facserver,Node} ! {self(),Message},
	receive
		{ok,Res} -> 
					Res
	after 1000 ->
					{error,timeout}
	end.
	

server() -> 
	register(facserver,self()),
	facloop().

facloop() ->
	receive
		{stop,Cause}	-> 
			io:format("Stopped by cause:~s~n",[Cause]),
			{stop,Cause};
		{Pid,N}	-> 
			Pid ! {ok,fac(N)},
			facloop()
	end.		


		
stop(Node) ->
	{facserver,Node} ! {stop,"Because STOP!"}.