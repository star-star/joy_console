-module(joy_console_session_evt).
-behaviour(joy_tcp_state).

-export([on_start/1,
         on_stop/1,
         on_connected/1]).

on_start(_Port) ->
    ok.

on_stop(_Port) ->
    ok.

on_connected(Socket) ->
    {ok, Pid} = joy_console_session_sup:start_child(Socket),
    gen_tcp:controlling_process(Socket, Pid).
