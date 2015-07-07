-module(champ_stat).

-export([get_stat/1]).

get_stat(Champ) ->
    
    F = fun(Elem,Acc) ->
	case Elem of
	    [] -> Acc;
	    {team,_,PL} -> 
		{NumTeams, NumPlayers, AvgAge, AvgRating} = Acc,
		{NumP,TAge,TRating} = lists:foldl(fun(P,Acc2) -> 
							  {player, _, Age, Rating, _} = P,
							  {NumP,TAge,TRating} = Acc2,
							  {NumP+1,TAge + Age,TRating + Rating} end,
				   {0,0,0},
				   PL),
		
		{NumTeams + 1, NumPlayers + NumP, AvgAge+TAge, AvgRating + TRating}
        end
    end,	
    {NumTeams, NumPlayers, AvgAge, AvgRating} =  lists:foldl(F,{0,0,0,0},Champ),
    {NumTeams, NumPlayers, AvgAge/NumPlayers, AvgRating/NumPlayers}.
