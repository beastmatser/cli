#!/usr/bin/env bash

# for github actions
if ! command -v odin > /dev/null; then
    cd Odin
    ./odin run ../run_tests.odin -file
    exit 0
fi

odin run run_tests.odin -file
rm -f ./run_tests
