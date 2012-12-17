all:get-deps
	@./rebar compile

get-deps:
	@./rebar get-deps

clean:
	@./rebar clean
