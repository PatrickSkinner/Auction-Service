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
			receiver(NewClients);
		
		{place_bid, Client, Amount}->
			receiver(Clients)
			
	after 30*1000 ->
		io:format("Auction Ended.~n")
			
	end.
	
broadcast(Client, MR)->
	Auction = {MR},
	element(1, Client) ! {subscribe_auction, Auction}.