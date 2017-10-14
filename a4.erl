-module(a4).
-export([a4/0, receiver/2]).

a4() ->
	Clients = [],
	Auctions = [],
	MR = spawn(?MODULE, receiver, [Clients, Auctions] ),
	register(service, MR).
	
receiver(Clients, Auctions) ->
	receive
		{client_add, Id, Interests} ->
			NewClients = [{Id, Interests} | Clients],
			io:format("Client Added~n"),
			receiver(NewClients, Auctions);
			
		{client_remove, Id, Interests} ->
			NewClients = lists:keydelete(Id, 1, Clients),
			io:format("Client Removed~n"),
			receiver(NewClients, Auctions);
			
		{auction_add, Id, Interests} ->
			NewAuctions = [{Id, Interests} | Auctions],
			receiver(Clients, NewAuctions);
			
		{auction_remove, Id, Interests} ->
			NewAuctions = lists:keydelete(Id, 1, Auctions),
			receiver(Clients, NewAuctions)
			
	end.
