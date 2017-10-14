-module(client).
-export([client/0, receiver/1]).

client()->
	MR = spawn(?MODULE, receiver, [[]]),
	service ! {client_add, MR, [1,3]}.
	%service ! {client_remove, MR, [1,3]}.

	
receiver(Auctions) ->
	receive
		{subscribe_auction, Auction} ->
			io:format("Subscribed to new auction~n"),
			
			NewAuctions = [Auction | Auctions],
			receiver(NewAuctions)
	end.