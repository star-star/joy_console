-module(joy_console_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-export([start/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() -> 
    application:start(crypto),
    application:start(ranch),
    application:start(joy_console).

start(_StartType, _StartArgs) ->

    init_profile(),
    init_port(1024),
    init_net(1025),
    joy_console_sup:start_link().

stop(_State) ->
    ok.

init_net(Port) ->
	Res = ranch:start_listener(joy_console, 1,
		ranch_tcp, [{port, Port}], joy_console_protocol, []),
    lager:info("ranch start listener:~p", [Res]).
	

init_port(Port) ->
    joy_net:start_tcp_listener(Port, joy_console_session_evt, [{active, true},
                                                               {packet_size, 0}]).


init_profile() ->
    lager:info("init profile"),
    init_cprof(),
    init_fprof().

init_cprof() ->
    ok.

init_fprof() ->
    ok.


prof_output() ->
    ok.

