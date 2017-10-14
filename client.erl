-module(client).
-export([client/0]).

client()->
	service ! {client_add, self(), [1,3]},
	service ! {client_remove, 5, [1,3]}.
	%MR = spawn(?MODULE, receiver, [[],[]] ).
	
receiver(Clients, Auctions) ->
	receive
		{_, Msg}->
			io:format("Client Received Message")
	end.