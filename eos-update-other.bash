#!/bin/bash

Main() {
    local -r progname=${0}
    local -r GREEN=$'\e[0;92m'
    local -r RESET=$'\e[0m'

    echo "${GREEN}==> $progname: a place for other update commands.${RESET}" >&2

    # Add your other update commands (e.g. for 'flatpak') here!
}

Main "$@"
