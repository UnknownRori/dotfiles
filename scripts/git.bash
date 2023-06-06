#! /usr/bin/env bash

# This should be sourced only since it's focused mainly on helping git workflow
# and checking if the shell has access to a git

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
RESET=$(tput sgr0)

# Some helper function for printing colored things
__error() {
    echo "${BOLD}${RED}[ERROR]${RESET}${TAB}: $1" >&2
}

__info() {
    echo "${BOLD}${INFO}[INFO]${RESET}${TAB}${TAB}: $1" >&2
}

__warning() {
    echo "${BOLD}${YELLOW}[WARNING]${RESET}${TAB}: $1" >&2
}

# For verbosity when sourced
verbose=
if ! [ $# -eq 0 ]; then
    if [ "$1" = "-v" ]; then
        verbose=true
        __info "Do system check..."
    fi
fi

# Check if terminal has access to git
if ! [ -x "$(command -v git)" ]; then
    __error "Git is not installed"
else
    if [ "$verbose" = true ]; then
        __info "Git is available"
    fi
fi

# Check if .gitconfig has gpgsign in it to allow sign commit
if [ -n "$(cat ~/.gitconfig | grep "gpgsign")" ]; then

    if [ "$verbose" = true ]; then
        __info "Git sign is available"
    fi

    git_sign=true
else 
    if [ "$verbose" = true ]; then
        __warning "Git sign is not available"
    fi

    git_sign=
fi

# Done system check
if [ "$verbose" = true ]; then
    __info "System check is done"
fi

# Custom Header
export _PS1="$PS1"

PS1="(${BOLD}${INFO}Git${RESET}) $PS1"

git-deactive(){
    export PS1="$_PS1"
    # export -n PS1

    unset -f git-status git-init git-add-all git-add-e git-commit-bugfix git-commit-feature git-commit-package git-push
    unset -f git-commit-fix git-commit-feat git-commit-pack git-commit-add git-tree git-commit-p git-commit
    unset -f git-pull git-prune git-commit git-amend git-diff-staged

    if [ "$verbose" = true ]; then
        __info "Gracefully shutdown..."
    fi
}

git-init() {
    git init
}

git-add-all() {
    git add -A
}

git-add-e() {
    git add -e "$@"
}

git-add() {
    if  [ $# -eq 0 ]; then
        __error "Require args"
        return
    fi

    git add "$@"
}

git-status() {
    git status
}

git-push() {
    if [ $# -eq 0 ]; then
        git push origin
        return
    fi

    git push "$@"
}

git-pull() {
    git pull "$@"
}

git-prune() {
    if [ $# -eq 0 ]; then
        git remote prune origin
        return
    fi

    git remote prune "$@"
}

git-diff() {
    git diff "$@" | cat
}

git-diff-staged() {
    git diff --staged | cat
}

git-tree() {
    git log --graph --pretty=oneline --abbrev-commit
}

git-commit() {
    git commit -epv
}

git-amend() {
    git commit --amend --no-edit
}

git-remote() {
    if [ $# -eq 0 ]; then
        git remote -v
        return
    fi

    git remote prune "$@"
}

git-commit-bugfix() {
    if [ -z "$1" ]; then
        __error "No git message provided!"
        return
    fi

    if [ "$git_sign" = true ]; then
        git commit -S -m "🛠️ $1"
        return
    fi
    git commit -m "🛠️ $1"
}

git-commit-fix() {
    git-commit-bugfix "$1"
}

git-commit-feat() {
    git-commit-feature "$1"
}

git-commit-feature() {
    if [ -z "$1" ]; then
        __error "No git message provided!"
        return
    fi


    if [ "$git_sign" = true ]; then
        git commit -S -m "🚀 $1"
        return
    fi
    git commit -m "🚀 $1"
}

git-commit-package() {
    if [ -z "$1" ]; then
        __error "No git message provided!"
        return
    fi


    if [ "$git_sign" = true ]; then
        git commit -S -m "📦 $1"
        return
    fi
    git commit -m "📦 $1"
}

git-commit-pack() {
    git-commit-package "$1"
}

git-commit-fire() {
    if [ -z "$1" ]; then
        __error "No git message provided!"
        return
    fi

    if [ "$git_sign" = true ]; then
        git commit -S -m "🔥 $1"
        return
    fi
    git commit -m "🔥 $1"
}

