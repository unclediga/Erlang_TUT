-module(myserver).

-export([start/0,loop/0]).

start() ->
   loop().

loop() -> 
   receive 
        {say,S} -> io:format("msg:~s~n",[S]),
		   loop();
	{out} -> io:format("Good Bye!",[]);
	_Any -> io:format("Not Resp Message!",[])
   
end.   
