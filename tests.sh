#!/usr/bin/env bash

# check if command 'odin' exists
if ! command -v odin > /dev/null; then
    alias odin='./odin'
fi

odin run run_tests.odin -file
rm -f ./run_tests
