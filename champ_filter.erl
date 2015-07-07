-module(champ_filter).

-export([filter_sick_players/1]).


filter_players(Players) ->
    lists:filter(fun(P) ->
			 case P of
			     {player,_,_,_,Helth} when Helth >= 50 -> true;
			     _Else -> false
			 end
		 end,
		 Players).
			

filter_sick_players(Champ) ->
    lists:filtermap(fun({team,Name,Players}) ->
			 NewPlayers = filter_players(Players),
			 Len = length(NewPlayers) > 3, 
			 if
			     Len > 3 -> {true,{team,Name,NewPlayers}};
			     true -> false 
			 end 
		    end,
		    Champ).







