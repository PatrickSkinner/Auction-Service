-module(client).
-export([client/0]).

client()->
	service ! client_add.
	% MR = spawn(?MODULE, receiver, [[],[]]).
	
receiver(Clients, Auctions)->
	receive
		{_, Msg}->
			io:format("Client Received Message")
	end.