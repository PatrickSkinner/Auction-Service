-module(client).
-export([client/0, receiver/1]).

client()->
	service ! {client_add, self(), [1,3]},
	%service ! {client_remove, self(), [1,3]},
	MR = spawn(?MODULE, receiver, [[]]).
	
receiver(Auctions) ->
	receive
		{subscribe_auction, Msg} ->
			io:format("Client Subscribed To Auction"),
			receiver(Auctions)
	end.