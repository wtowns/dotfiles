[[ $- == *i* ]] && . "$HOME/.bashrc"

# Init jenv
if which jenv > /dev/null; then eval "$(jenv init -)"; fi
