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
			receiver(NewAuctions, Interests);
		{won_auction, Auction} ->
			io:format("You Won An Auction~n"),
			NewAuctions = lists:keydelete(Auction, 1, Auctions),
			receiver(NewAuctions, Interests);
		{lost_auction, Auction} ->
			io:format("You Lost An Auction~n"),
			NewAuctions = lists:keydelete(Auction, 1, Auctions),
			receiver(NewAuctions, Interests)
			
	after 10*1000 ->
		NumAuctions = length(Auctions),
		if
			NumAuctions > 0 ->
				Index = rand:uniform( NumAuctions ),
				Auction = lists:nth(Index, Auctions),
				
				element(1, Auction) ! {place_bid, {self(), Interests}, rand:uniform( 25 ) },
				%element(1, Auction) ! {client_remove, self()},
				receiver(Auctions, Interests);
			true ->
				receiver(Auctions, Interests)
		end
	end.