-module(tic_tac_toe).

-export([new_game/0, win/1, move/3]).


new_game() ->
    {{f, f, f},
     {f, f, f},
     {f, f, f}}.


win(GameState) ->
    %% BEGIN

    case GameState of
	{{F1,F2,F3},_,_} when F1 == F2 andalso F1 == F3 andalso F1 /= f -> {win,F1};
	{_,_,{F1,F2,F3}} when F1 == F2 andalso F1 == F3 andalso F1 /= f -> {win,F1};
	{{F1,_,_},{F2,_,_},{F3,_,_}} when F1 == F2 andalso F1 == F3 andalso F1 /= f -> {win,F1};
	{{_,_,F1},{_,_,F2},{_,_,F3}} when F1 == F2 andalso F1 == F3 andalso F1 /= f -> {win,F1};

	{_,{_,F1,_},_} when F1 /= f -> 
	    case GameState of
		{{F2,_,_},_,{_,_,F3}} when F1 == F2 andalso F1 == F3 -> {win,F1};
		{{_,F2,_},_,{_,F3,_}} when F1 == F2 andalso F1 == F3 -> {win,F1};
		{{_,_,F2},_,{F3,_,_}} when F1 == F2 andalso F1 == F3 -> {win,F1};
		{_,{F2,_,F3},_} when F1 == F2 andalso F1 == F3 -> {win,F1};
		_ -> no_win 
	    end;
	_ -> no_win
    end.
    %% END



move(Cell, Player, GameState) ->
    %% BEGIN

    case [Cell,GameState] of
	[1,{{F1,F2,F3},R2,R3}] when F1 == f -> {ok,{{Player,F2,F3},R2,R3}};
	[2,{{F1,F2,F3},R2,R3}] when F2 == f -> {ok,{{F1,Player,F3},R2,R3}};
	[3,{{F1,F2,F3},R2,R3}] when F3 == f -> {ok,{{F1,F2,Player},R2,R3}};
	[4,{R1,{F1,F2,F3},R3}] when F1 == f -> {ok,{R1,{Player,F2,F3},R3}};
	[5,{R1,{F1,F2,F3},R3}] when F2 == f -> {ok,{R1,{F1,Player,F3},R3}};
	[6,{R1,{F1,F2,F3},R3}] when F3 == f -> {ok,{R1,{F1,F2,Player},R3}};
	[7,{R1,R2,{F1,F2,F3}}] when F1 == f -> {ok,{R1,R2,{Player,F2,F3}}};
	[8,{R1,R2,{F1,F2,F3}}] when F2 == f -> {ok,{R1,R2,{F1,Player,F3}}};
	[9,{R1,R2,{F1,F2,F3}}] when F3 == f -> {ok,{R1,R2,{F1,F2,Player}}};
	_ -> {error,invalid_move} 
    end.
	     
    
    %% END
