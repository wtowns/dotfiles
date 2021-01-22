# Init jenv
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# If this is an interactive shell, run .bashrc
[[ $- == *i* ]] && . "$HOME/.bashrc"
