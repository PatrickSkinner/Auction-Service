-module(client).
-export([client/0, receiver/2]).

client()->
	Interests = [1, 3],
	MR = spawn(?MODULE, receiver, [[], Interests]),
	service ! {client_add, MR, Interests}.
	%service ! {client_remove, MR}.

	
receiver(Auctions, Interests) ->
	receive
		{subscribe_auction, Auction} ->
			io:format("Subscribed to new auction~n"),
			
			NewAuctions = [Auction | Auctions],
			receiver(NewAuctions, Interests)
	after 10*1000 ->
		Index = rand:uniform( length(Auctions) ),
		%io:format("Bidding on Auction No: ~w~n", [Index]),
		Auction = lists:nth(Index, Auctions),
		
		element(1, Auction) ! {place_bid, {self(), Interests}, rand:uniform( 25 ) },
		receiver(Auctions, Interests)
		
	end.