-module(champ_pairs).

-export([make_pairs/2]).


make_pairs(Team1, Team2) ->
    {team,_,P1} = Team1, 
    {team,_,P2} = Team2, 
    [{Name1,Name2} || 
	{player,Name1,_,Rating1,_} <- P1,
	{player,Name2,_,Rating2,_} <- P2,
	Rating1 + Rating2 > 600].
	
	
		      
    
