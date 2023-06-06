#! /usr/bin/env bash

# Check if tput is available
if [ command -v tput &> /dev/null ]; then
    echo "[WARNING]: tput is not installed" >&2
    # Formatting & Coloring
    BOLD=
    UNDERLINE=
    ITALIC=

    ERROR=
    INFO=

    GREEN=
    YELLOW=
    RED=
    WHITE=

    color_prompt=
else
    # Formatting & Coloring
    BOLD=$(tput bold)
    UNDERLINE=$(tput smul)
    ITALIC=$(tput sitm)

    ERROR=$(tput setaf 214)
    INFO=$(tput setaf 2)

    GREEN="$INFO"
    YELLOW=$(tput setaf 180)
    RED=$(tput setaf 1)
    WHITE=$(tput setaf 7)

    color_prompt=true
fi

# More Formatting
NEWLINE=$'\n'
TAB=$'\t'

# Some helper function for printing colored things
__error() {
    echo "${BOLD}${RED}[ERROR]${RESET}${TAB}${TAB}: $1" >&2
}

__info() {
    echo "${BOLD}${INFO}[INFO]${RESET}${TAB}${TAB}: $1" >&2
}

__warning() {
    echo "${BOLD}${YELLOW}[WARNING]${RESET}${TAB}: $1" >&2
}

# Custom Header
export _PS1="$PS1"

PS1="(${BOLD}${INFO}Telescope${RESET}) $PS1"

tlsp-deactive() {
    export PS1="$_PS1"
    unset -f search
}

tlsp-search() {
    file="./$(command fzf -q "$@")"
    bat $file -r :18
}

tlsp-search-f() {
    file="./$(command fzf -q "$@")"
    bat $file -r :18
}