%% Feel free to use, reuse and abuse the code in this file.

-module(joy_console_protocol).
-export([start_link/4, init/4]).

-behaviour(ranch_protocol).

-record(state, {listenerPid,
                socket,
                transport}).

start_link(ListenerPid, Socket, Transport, Opts) ->
	Pid = spawn_link(?MODULE, init, [ListenerPid, Socket, Transport, Opts]),
	{ok, Pid}.

init(ListenerPid, Socket, Transport, _Opts = []) ->
	ok = ranch:accept_ack(ListenerPid),
    Transport:send(Socket, <<"Welcome!\r\n">>),
    loop(<<>>, #state{listenerPid = ListenerPid,
                      socket      = Socket,
                      transport   = Transport}).


loop(Buffer, State = #state{socket    = Socket,
                            transport = Transport}) ->
	case Transport:recv(Socket, 0, 5000) of
		{ok, Data} ->
            NewBuffer = parse_cmd_line(<<Buffer/binary, Data/binary>>), 
			loop(NewBuffer, State);
		_ ->
            Transport:send(Socket, <<"Bye!">>),
			ok = Transport:close(Socket)
	end.


parse_cmd_line(Buffer) ->
    lager:info("buffer:~p", [Buffer]),
    case binary:match(Buffer, <<"\r\n">>) of
        nomatch ->
            Buffer;
        {_, _} ->
            [Cmd, NewBuffer] = binary:split(Buffer, <<"\r\n">>),
            lager:info("ori:~p cmd:~p buffer:~p", [Buffer, Cmd, NewBuffer]),
            NewBuffer

    end.



