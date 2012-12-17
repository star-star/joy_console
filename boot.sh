#!/bin/bash
erl -pa ./ebin -s joy_tools_app -boot start_sasl -config ebin/joy_tools.config

