-module(joy_console_session).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {socket,
                buffer}).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(Socket) ->
    gen_server:start_link(?MODULE, [Socket], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([Socket]) ->
    gen_tcp:send(Socket, <<"hello">>),
    {ok, #state{socket = Socket,
                buffer = []}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({tcp_closed, _Socket}, State) ->
    {stop, normal, State};

handle_info({tcp, _Socket, Bin}, 
                    State = #state{buffer = Buffer}) ->
    NewBuffer = [Bin | Buffer],
    io:format("Buffer:~p~n", [NewBuffer]),
    {noreply, State#state{buffer = NewBuffer}};

handle_info(_Info, State) ->
    io:format("unknown:~p~n", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    io:format("session closed~n"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

