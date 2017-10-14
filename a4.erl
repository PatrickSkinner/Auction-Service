-module(a4).
-export([a4/0, receiver/1]).

a4()->
	MR = spawn(?MODULE, receiver, [[]]),
	register(service, MR).
	
receiver(Clients)->
	receive
		{client_join, Msg} ->
			NewClients = [{Msg} | Clients],
			receiver(NewClients);
			
		{client_leave, Msg} ->
			NewClients = lists:keydelete(Msg, 1, Clients),
			receiver(NewClients)
	end.
	
