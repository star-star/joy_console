-module(joy_console_session_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/1]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) -> 
   	SupFlags = {simple_one_for_one, 5, 10},

	Session   = {'joy_console_session', {joy_console_session, start_link, []},
                                             temporary, brutal_kill, worker, dynamic},

	{ok,{SupFlags,[Session]}}.


start_child(Socket) ->
    supervisor:start_child(?MODULE, [Socket]).


