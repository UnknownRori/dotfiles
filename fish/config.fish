if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Check if bat available so it can be aliased as cat instead
if type -q bat
    alias cat=bat
end

# Check if neovim available so it can be aliased as nv instead
if type -q nvim
    alias nv=nvim
end

# Check if neovide available so it can be aliased as nvi instead
if type -q neovide
    alias nvi="neovide --multigrid "
end

# Alias
alias phpunit="./vendor/phpunit/phpunit/phpunit"
alias phpunit:coverage="phpunit --coverage-text --path-coverage"
alias artisan="php artisan"
alias spark="php spark"
alias serve="php -S 127.0.0.1:8000"
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
alias q="exit"
alias c="code ."
alias co="codium ."
alias cls="clear"
alias lss="ls -al"
alias l="lss"
alias restart="shutdown -r -t 10"
alias poweroff="shutdown -s -t 10"
alias pq="poweroff && exit"
alias resource="source ~/.config/fish/config.fish"
alias loc="cloc . --quiet --hide-rate"
alias procs="procps -AmLw vac"

if type -q starship
    starship init fish | source
end
