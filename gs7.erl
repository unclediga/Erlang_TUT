-module(gs7).

    -export([start/0, add_item/2, remove_item/2, show_items/1, stop/1, loop/1]).

    start() ->
        InitialState = [],
        spawn(?MODULE, loop, [InitialState]).

    add_item(Pid,Item) ->
        call(Pid,{add,Item}).

    remove_item(Pid,Item) ->
        call(Pid,{remove,Item}).

    show_items(Pid) ->
        call(Pid,show_items).

    call(Pid,Msg) ->
      Ref = make_ref(),
      Pid ! {Msg,self(),Ref},
      receive
         {replay,Ref,Replay} -> Replay
      after 5000 -> no_replay   
      end.


    stop(Pid) ->
        Pid ! stop,
        ok.


    loop(State) ->
        receive
            {{add,Item}, From,Ref} -> 
                NewState = [Item | State],
                From ! {replay,Ref,ok},
                ?MODULE:loop(NewState);

            {{remove, Item}, From,Ref} -> 
                {Replay, NewState} = 
                  case lists:member(Item, State) of
                    true -> {ok, lists:delete(Item, State)};
                    false ->{{error, no_exist},State}
                  end,  
                  From ! {replay,Ref, Replay},
                  ?MODULE:loop(NewState);

            {show_items,From,Ref} -> From ! {replay,Ref, State},
                                 ?MODULE:loop(State);

            stop -> io:format("~p stops now ~n", [self()]),
                    ok;

            _Any -> ?MODULE:loop(State)
        end.