-module(auction).
-export([auction/0, receiver/1]).

auction()->
	service ! {auction_add, self(), []},
	MR = spawn(?MODULE, receiver, [[]]).
	
receiver(Clients)->
	receive
		{_, Msg}->
			io:format("Auction Received Message")
	end.