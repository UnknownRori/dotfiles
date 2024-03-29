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

    RESET=

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

    RESET=$(tput sgr0)

    color_prompt=true
fi

# More Formatting
NEWLINE=$'\n'
TAB=$'\t'

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

# Setting Git Prompt Variable
GIT_PS1_DESCRIBE_STYLE='contains'
GIT_PS1_SHOWCOLORHINTS='y'
GIT_PS1_SHOWDIRTYSTATE='y'
GIT_PS1_SHOWSTASHSTATE='y'
GIT_PS1_SHOWUNTRACKEDFILES='y'
GIT_PS1_SHOWUPSTREAM='auto'

# Backup the old PS1
export _PS1="$PS1"

# Custom Header
if [ "$color_prompt" = true ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\W\[\033[00m\] ${INFO}$(__git_ps1)${RESET} > '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W $(__git_ps1) > '
fi
unset color_prompt force_color_prompt

# Export some variable
# export RUST_BACKTRACE="full"

# Alias
alias phpunit="./vendor/phpunit/phpunit/phpunit"
alias phpunit:coverage="phpunit --coverage-text --path-coverage"
alias artisan="php artisan"
alias spark="php spark"
alias serve="php -S 127.0.0.1:8000"
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
alias q="exit"
# alias c="code ."
# alias co="codium ."
alias c="codium ."
alias cls="clear"
alias lss="ls -al --color"
alias l="lss"
alias restart="shutdown -r -t 10"
alias poweroff="shutdown -s -t 10"
alias pq="poweroff && exit"
alias pr="restart && exit"
alias resource="source ~/.bashrc"
alias loc="cloc . --quiet --hide-rate"
alias procs="procps -AmLw vac"
alias tok=tokei
alias komorebic:start="komorebic start -c $Env:USERPROFILE/komorebi.json --whkd"

alias mysql:start="systemd start mysql"
alias sqlserver:start="systemd start MSSQLSERVER"
alias postgres:start="systemd start postgresql-x64-14"
alias rabbitmq:start="systemd start RabbitMQ"
alias memurai:start="systemd start memurai"
alias redis:start="systemd start memurai"
alias apache:start="systemd start apache2.4"

alias mysql:stop="systemd stop mysql"
alias sqlserver:stop="systemd stop MSSQLSERVER"
alias postgres:stop="systemd stop postgresql-x64-14"
alias rabbitmq:stop="systemd stop RabbitMQ"
alias memurai:stop="systemd stop memurai"
alias redis:stop="systemd stop memurai"
alias apache:stop="systemd stop apache2.4"

# Check if bat available so it can be aliased as cat instead
if [ -x "$(command -v bat)" ]; then
    alias cat=bat
fi

# Check if bat available so it can be aliased as cat instead
if [ -x "$(command -v eza)" ]; then
    alias ls="eza --icons --sort=name --group-directories-first"

    alias lss="ls -al --icons"
    alias lt="ls --tree --icons"
    alias l="lss"
fi

if [ -x "$(command -v zoxide)" ]; then
    eval "$(zoxide init bash)"
    alias cd="z"
fi


# Check if neovim available so it can be aliased as nv instead
if [ -x "$(command -v nvim)" ]; then
    alias nv=nvim
fi

# Check if neovide available so it can be aliased as nvi instead
if [ -x "$(command -v neovide)" ]; then
    alias nvi="neovide --multigrid "
fi

objdumpx() {
    if [ -x "$(command -v bat)" ]; then
        objdump $@ -d | cat -l nasm
        return;
    fi

    objdump $@ -d | cat
    return;
}

# Create a directory and open it
mkdir2(){
    if [ $# -eq 0 ]; then
       __error "Need some parameter"
       return
    fi

    mkdir "$@"
    cd "$@"
}

# For displaying color
_color(){
    for c; do
        printf '\e[48;5;%dm%03d' $c $c
    done
    printf '\e[0m \n'
}

color() {
    IFS=$' \t\n'
    _color {0..15}
    for ((i=0;i<6;i++)); do
        _color $(seq $((i*36+16)) $((i*36+51)))
    done
    _color {232..255}
}

if [ -x "$(command -v starship)" ]; then
    eval "$(starship init bash)"
fi

# Nu shell
if [ -x "$(command -v nu)" ]; then
    nu
fi
