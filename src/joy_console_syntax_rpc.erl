%% Feel free to use, reuse and abuse the code in this file.
-module(joy_console_syntax_rpc).

-behaviour(joy_console_syntax).


-export([parse/1]).

parse(Cmd) ->
    CmdStr = binary_to_list(Cmd),
    lager:info("cmd:~p", [Cmd]),
    ok.
