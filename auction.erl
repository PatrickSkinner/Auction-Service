-module(auction).
-export([auction/0]).

auction()->
	service ! {auction_add, self(), []},
	MR = spawn(?MODULE, receiver, [[],[]]).
	
receiver(Clients, Auctions)->
	receive
		{_, Msg}->
			io:format("Auction Received Message")
	end.