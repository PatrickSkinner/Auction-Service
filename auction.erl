-module(auction).
-export([auction/0, receiver/1]).

auction()->
	MR = spawn(?MODULE, receiver, [[]]),
	io:format("Auction PID: ~w~n", [MR]),
	service ! {auction_add, MR, []}.
	
receiver(Client)->
	receive
		{client_add, Msg}->
			io:format("Client Subscribed To Auction~n"),
			receiver(Client)
	end.