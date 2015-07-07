-module(gs1).

-export([start/0]).

start() ->
	io:format("start ~p~n",[self()]),
	spawn(fun loop/0).


loop() ->
   io:format("~p enters loop ~n", [self()]), 
%%   exit(foobar),
%%   io:format("~p exit loop ~n", [self()]),
   receive 
   		stop -> io:format("~p stop now~n",[self()]);
   		Msg	 -> io:format("~p receive ~p ~n",[self(),Msg]),
   			    loop() 
   end.

