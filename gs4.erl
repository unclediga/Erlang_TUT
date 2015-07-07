-module(gs4).

    -export([start/0, add_item/2, remove_item/2, show_items/1, stop/1, loop/1]).

    start() ->
        InitialState = [],
        spawn(?MODULE, loop, [InitialState]).

    add_item(Pid,Item) ->
        Pid ! {add,self(),Item},
        receive
          {replay,Replay} -> Replay
        end.

    remove_item(Pid,Item) ->
        Pid ! {remove,self(),Item},
        receive
          {replay,Replay} -> Replay
        end.

    show_items(Pid) ->
        Pid ! {show_items,self()},
        receive
          {replay,Replay} -> Replay
        end.

    stop(Pid) ->
        Pid ! stop,
        ok.


    loop(State) ->
        receive
            {add, From, Item} -> 
                NewState = [Item | State],
                From ! {replay,ok},
                ?MODULE:loop(NewState);

            {remove, From, Item} -> 
                {Replay, NewState} = 
                  case lists:member(Item, State) of
                    true -> {ok, lists:delete(Item, State)};
                    false ->{{error, no_exist},State}
                  end,  
                  From ! {replay,Replay},
                  ?MODULE:loop(NewState);

            {show_items,From} -> From ! {replay, State},
                                 ?MODULE:loop(State);

            stop -> io:format("~p stops now ~n", [self()]),
                    ok;

            _Any -> ?MODULE:loop(State)
        end.