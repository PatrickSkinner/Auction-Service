-module(a4).
-export([a4/0, receiver/2]).

a4()->
	MR = spawn(?MODULE, receiver, [[],[]]),
	register(service, MR).
	
receiver(Clients, Auctions)->
	receive
		{client_add, Msg} ->
			NewClients = [{Msg} | Clients],
			io:format("Client Added"),
			receiver(NewClients, Auctions);
			
		{client_remove, Msg} ->
			NewClients = lists:keydelete(Msg, 1, Clients),
			io:format("Client Removed"),
			receiver(NewClients, Auctions);
			
		{auction_add, Msg} ->
			NewAuctions = [{Msg} | Auctions],
			receiver(Clients, NewAuctions);
			
		{auction_remove, Msg} ->
			NewAuctions = lists:keydelete(Msg, 1, Auctions),
			receiver(Clients, NewAuctions)
	end.
	
