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

# System check
verbose=
health=0
if ! [ $# -eq 0 ]; then
    if [ "$1" = "-v" ]; then
        verbose=true
        __info "Do system check..."
    fi
fi

if ! [ -x "$(command -v php)" ]; then
    __error "php is not available!"
elif [ "$verbose" = true ]; then
    __info "php is available"
fi


if [ "$verbose" = true ]; then
    if ! [ -x "$(command -v npm)" ]; then
        __error "npm is not available!"
    else
        __info "npm is available"
    fi

    if ! [ -f "artisan" ]; then
        __warning "artisan is not available!"
    else
        __info "artisan is available"
    fi
fi

# Done system check
if [ "$verbose" = true ]; then
    __info "System check is done${NEWLINE}"
fi

# Additional Info
__info "All command start with lv-"

# Custom Header
export _PS1="$PS1"

PS1="(${BOLD}${INFO}Laravel${RESET}) $PS1"

# Alias
alias artisan="php artisan"
# For typo
alias artinas=artisan
alias artisaan=artisan
alias artisa=artisan
alias artis=artisan
alias arti=artisan
alias arit=artisan
alias art=artisan

lv-deactive(){
    export PS1="$_PS1"
    # export -n PS1

    # General
    unset -f lv-help lv-serve lv-clone lv-create-project lv-install-essential lv-keygen lv-autoload lv-reset

    # DB
    unset -f lv-db-migrate lv-db-seed lv-db-fresh-seed
    
    # Make
    unset -f lv-make lv-make-service lv-make-enum lv-make-controller
    unset -f lv-make-apicontroller lv-make-invokecontroller lv-make-resourcecontroller lv-make-singletoncontroller
    unset -f lv-make-middleware lv-make-model lv-make-policy lv-make-event lv-make-observer lv-make-notification
    unset -f lv-make-migration lv-make-resource lv-make-cast

    unalias artinas artisa artis arti arit art

    if [ "$verbose" = true ]; then
        __info "Gracefully shutdown"
    fi
}

# Global Help
lv-help() {
    echo "Laravel Helper Scripts"
    lv-make
}

lv-serve() {
    if ! [ -d "node_modules" ]; then
        if [ "$verbose" = true ]; then
            __warning "Cannot run npm run dev if ${INFO}node_modules${RESET} is not exists!"
        fi
        artisan serv
        return
    fi

    artisan serv & npm run dev
}

lv-create-project() {
    composer create-project "laravel/laravel" "$1"
}

lv-install-essential() {
    composer require "barryvdh/laravel-ide-helper" --dev && composer require "barryvdh/laravel-debugbar" --dev
}

lv-clone() {
    echo "This command is still in experimental"
    if ! [ -x "$(command -v git)" ]; then
        __error "Didn't have git installed!"
        return
    fi

    if [ -z "$1" ]; then
        __error "No git repository link provided"
        return
    fi

    git clone "$1"
    _file_path=$(basename "$1") # for future use?
    cd _file_path
    lv-install
}

lv-install() {
    composer install
    cp .env.example .env
    lv-keygen
}

lv-keygen() {
    artisan key:generate
}

lv-autoload() {
    composer dump-autoload
}

lv-reset() {
    artisan cache:clear & artisan route:clear & artisan view:clear & artisan migrate:fresh --seed
}

lv-db-fresh-seed() {
    artisan migrate:fresh --seed
}

lv-db-migrate() {
    artisan migrate
}

lv-db-seed() {
    artisan db:seed
}

# Help
lv-make() {
    echo "${INFO}User defined${RESET}"
    echo "  lv-make-service               \$filename"
    echo "  lv-make-enum                  \$filename"
    echo "${INFO}Controller${RESET}"
    echo "  lv-make-controller            <laravel-param>"
    echo "  lv-make-apicontroller         <laravel-param>"
    echo "  lv-make-invokecontroller      <laravel-param>"
    echo "  lv-make-resourcecontroller    <laravel-param>"
    echo "  lv-make-singletoncontroller   <laravel-param>"
    echo "${INFO}Middleware${RESET}"
    echo "  lv-make-middleware            <laravel-param>"
    echo "${INFO}Model${RESET}"
    echo "  lv-make-model                 <laravel-param>"
    echo "  lv-make-policy                <laravel-param>"
    echo "${INFO}Event${RESET}"
    echo "  lv-make-event                 <laravel-param>"
    echo "  lv-make-observer              <laravel-param>"
    echo "  lv-make-notification          <laravel-param>"
    echo "${INFO}DB${RESET}"
    echo "  lv-make-migration             <laravel-param>"
    echo "${INFO}Eloquent${RESET}"
    echo "  lv-make-resource              <laravel-param>"
    echo "  lv-make-cast                  <laravel-param>"
}

# Service

lv-make-service() {
    if [ -z $1 ]; then
        __error "Need filename"
        return
    fi


    path="./app/Services"
    if ! [ "$(dirname $1)" = "." ]; then
        path="$path$(dirname $1)"
    fi

    file="$(command basename $1)"

    _write_() {
        echo "<?php" > "$path/$1.php"
        echo "" >> "$path/$1.php"
        echo "namespace App\\Services;" >> "$path/$1.php"
        echo "" >> "$path/$1.php"
        echo "class $1" >> "$path/$1.php"
        echo "{" >> "$path/$1.php"
        echo "    //" >> "$path/$1.php"
        echo "}" >> "$path/$1.php"
    }

    if ! [[ -f "$path/$1.php" ]]; then
        mkdir -p "$path"
        _write_ "$file"
        unset -f _write_
        return
    fi

    __warning "File already exists! overwrite[Y/t] : "
    read -r overwrite
    for (( ; ; )); do
        if [ "$overwrite" = "Y" ] | [ "$overwrite" = "y" ]; then
            _write_ "$file"
            __info "File created $1/$file.php"
            break
        fi

        if [ "$overwrite" = "T" ] | [ "$overwrite" = "t" ]; then
            break
        fi
    done

    unset -f _write_
}

# Enum

lv-make-enum() {
    if [ -z $1 ]; then
        __error "Need filename"
        return
    fi


    path="./app/Enums"
    if ! [ "$(dirname $1)" = "." ]; then
        path="$path$(dirname $1)"
    fi

    file="$(command basename $1)"

    _write_() {
        echo "<?php" > "$path/$1.php"
        echo "" >> "$path/$1.php"
        echo "namespace App\\Enums;" >> "$path/$1.php"
        echo "" >> "$path/$1.php"
        echo "enum $1" >> "$path/$1.php"
        echo "{" >> "$path/$1.php"
        echo "    //" >> "$path/$1.php"
        echo "}" >> "$path/$1.php"
    }

    if ! [[ -f "$path/$1.php" ]]; then
        mkdir -p "$path"
        _write_ "$file"
        unset -f _write_
        return
    fi

    __warning "File already exists! overwrite[Y/t] : "
    read -r overwrite
    for (( ; ; )); do
        if [ "$overwrite" = "Y" ] | [ "$overwrite" = "y" ]; then
            _write_ "$file"
            __info "File created $1/$file.php"
            break
        fi

        if [ "$overwrite" = "T" ] | [ "$overwrite" = "t" ]; then
            break
        fi
    done

    unset -f _write_
}

# Traits

lv-make-trait() {
    if [ -z $1 ]; then
        __error "Need filename"
        return
    fi


    path="./app/Traits"
    if ! [ "$(dirname $1)" = "." ]; then
        path="$path$(dirname $1)"
    fi

    file="$(command basename $1)"

    _write_() {
        echo "<?php" > "$path/$1.php"
        echo "" >> "$path/$1.php"
        echo "namespace App\\Traits;" >> "$path/$1.php"
        echo "" >> "$path/$1.php"
        echo "trait $1" >> "$path/$1.php"
        echo "{" >> "$path/$1.php"
        echo "    //" >> "$path/$1.php"
        echo "}" >> "$path/$1.php"
    }

    if ! [[ -f "$path/$1.php" ]]; then
        mkdir -p "$path"
        _write_ "$file"
        unset -f _write_
        return
    fi

    __warning "File already exists! overwrite[Y/t] : "
    read -r overwrite
    for (( ; ; )); do
        if [ "$overwrite" = "Y" ] | [ "$overwrite" = "y" ]; then
            _write_ "$file"
            __info "File created $1/$file.php"
            break
        fi

        if [ "$overwrite" = "T" ] | [ "$overwrite" = "t" ]; then
            break
        fi
    done

    unset -f _write_
}

# Model

lv-make-model() {
    artisan make:model "$@"
}

lv-make-policy() {
    artisan make:policy "$@"
}

# Controller

lv-make-controller() {
    artisan make:controller "$@"
}

lv-make-apicontroller() {
    artisan make:controller "$@" --api
}

lv-make-invokecontroller() {
    artisan make:controller "$@" --invoke
}

lv-make-resourcecontroller() {
    artisan make:controller "$@" --resource
}

lv-make-singletoncontroller() {
    artisan make:controller "$@" --singleton
}

# Migration

lv-make-migration() {
    artisan make:migration "$@"
}

# Middleware

lv-make-middleware() {
    artisan make:middleware "$@"
}

# Event

lv-make-observer() {
    artisan make:observer "$@"
}

lv-make-event() {
    artisan make:event "$@"
}

lv-make-notification() {
    artisan make:notification "$@"
}

# View Component

lv-make-component() {
    artisan make:component "$@"
}

# Cast

lv-make-resource() {
    artisan make:resource "$@"
}

lv-make-cast() {
    artisan make:cast "$@"
}
