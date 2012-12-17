-module(joy_console_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-export([start/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() -> application:start(joy_console).

start(_StartType, _StartArgs) ->
    init_port(1024),
    joy_console_sup:start_link().

stop(_State) ->
    ok.


init_port(Port) ->
    joy_net:start_tcp_listener(Port, joy_console_session_evt, []).
