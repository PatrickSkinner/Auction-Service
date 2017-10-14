-module(auction).
-export([auction/0, receiver/1]).

auction()->
	MR = spawn(?MODULE, receiver, [[]]),
	io:format("Auction PID: ~w~n", [MR]),
	service ! {auction_add, MR, []}.
	
receiver(Clients)->
	receive
		{client_add, Client}->
			io:format("Client Subscribed To Auction~n"),
			
			NewClients = [Client | Clients],
			broadcast(Client, self()),
			receiver(NewClients)
	end.
	
broadcast(Client, MR)->
	element(1, Client) ! {subscribe_auction, MR}.