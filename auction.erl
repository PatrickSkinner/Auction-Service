-module(auction).
-export([auction/0, receiver/2]).

auction()->
	MR = spawn(?MODULE, receiver, [[], 0]),
	io:format("Auction PID: ~w~n", [MR]),
	service ! {auction_add, MR, []}.
	
receiver(Clients, Bid)->
	receive
		{client_add, Client}->
			io:format("Client Subscribed To Auction~n"),
			
			NewClients = [Client | Clients],
			broadcast(Client, self()),
			receiver(NewClients, Bid);
		
		{place_bid, Amount}->
			if 
				Amount > Bid ->
					NewBid = Amount;
				true -> 
					NewBid = Bid
			end,
			io:format("Amount bid: ~w~n" [Amount]),
			io:format("Highest Bid: ~w~n", [NewBid]),
			receiver(Clients, NewBid)
			
	after 30*1000 ->
		io:format("Auction Ended.~n")
			
	end.
	
broadcast(Client, MR)->
	Auction = {MR},
	element(1, Client) ! {subscribe_auction, Auction}.