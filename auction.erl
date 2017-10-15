-module(auction).
-export([auction/0, receiver/3]).

auction()->
	MR = spawn(?MODULE, receiver, [[], 0, 0]),
	io:format("Auction PID: ~w~n", [MR]),
	service ! {auction_add, MR, []}.
	
receiver(Clients, Bid, Leader)->
	receive
		{client_add, Client}->
			io:format("Client Subscribed To Auction~n"),
			
			NewClients = [Client | Clients],
			broadcast(Client, self()),
			receiver(NewClients, Bid, Leader);
		
		{place_bid, From, Amount}->
			if 
				Amount > Bid ->
					NewLeader = From,
					NewBid = Amount;
				true -> 
					NewLeader = Leader,
					NewBid = Bid
			end,
			io:format("Amount bid: ~w~n", [Amount]),
			io:format("Highest Bid: ~w~n", [NewBid]),
			receiver(Clients, NewBid, NewLeader)
			
	after 30*1000 ->
		io:format("Auction Ended.~n")
			
	end.
	
broadcast(Client, MR)->
	Auction = {MR},
	element(1, Client) ! {subscribe_auction, Auction}.