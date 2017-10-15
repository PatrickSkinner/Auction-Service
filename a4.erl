-module(a4).
-export([a4/0, receiver/2]).

a4() ->
	MR = spawn(?MODULE, receiver, [ [], [] ] ),
	register(service, MR).
	
receiver(Clients, Auctions) ->
	receive
		{client_add, Id, Interests} ->
			NewClients = [{Id, Interests} | Clients],
			io:format("Client Added~n"),
			%io:format("~w~n", [lists:flatlength(NewClients)]),
			
			broadcastClient({Id, Interests}, Auctions),
			receiver(NewClients, Auctions);
			
		{client_remove, Id, Interests} ->
			NewClients = lists:keydelete(Id, 1, Clients),
			io:format("Client Removed~n"),
			
			receiver(NewClients, Auctions);
			
		{auction_add, Id, Interests} ->
			NewAuctions = [{Id, Interests} | Auctions],
			io:format("Auction Added~n"),
			
			timer:send_after(30*1000, Id, {end_auction}),
			receiver(Clients, NewAuctions);
			
		{auction_remove, Id} ->
			NewAuctions = lists:keydelete(Id, 1, Auctions),
			receiver(Clients, NewAuctions)
			
	end.
	
broadcastClient( Client, []) ->
	io:format("end"),
	ok;
broadcastClient( Client, Auctions ) ->
	[Auction |Tail] = Auctions,
	%io:format("Iteration of Auctions ~w~n", [element(1, Auction)]),
	
	element(1, Auction) ! {client_add, Client},
	broadcastClient( Client, Tail).
