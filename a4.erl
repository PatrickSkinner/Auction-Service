-module(a4).
-export([a4/0, receiver/2]).

a4() ->
	MR = spawn(?MODULE, receiver, [[],[]]),
	register(service, MR).
	
receiver(Clients, Auctions) ->
	receive
		{client_add, ID, Interests} ->
			NewClients = [{ID, Interests} | Clients],
			io:format("Client Added"),
			receiver(NewClients, Auctions);
			
		{client_remove, ID, Interests} ->
			NewClients = lists:keydelete(ID, Interests, 1, Clients),
			io:format("Client Removed"),
			receiver(NewClients, Auctions);
			
		{auction_add, ID, Interests} ->
			NewAuctions = [{ID, Interests} | Auctions],
			receiver(Clients, NewAuctions);
			
		{auction_remove, ID, Interests} ->
			NewAuctions = lists:keydelete(ID, Interests, 1, Auctions),
			receiver(Clients, NewAuctions)
			
	end.
