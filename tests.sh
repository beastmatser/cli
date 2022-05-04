#!/usr/bin/env bash

# for github actions
if ! command -v odin > /dev/null; then
    cd Odin
    ./odin run ../tests
    exit 0
fi

odin run tests
rm -f tests/.bin
