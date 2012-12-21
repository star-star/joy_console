%% Feel free to use, reuse and abuse the code in this file.
-module(joy_console_syntax).
-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [{parse,1}];
    

behaviour_info(_Other) ->
    undefined.
