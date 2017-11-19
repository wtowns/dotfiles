# Use vi mode
set -o vi

# ^p check for partial match in history
bind -m vi-insert "\C-p":dynamic-complete-history

# ^n cycle through the list of partial matches
bind -m vi-insert "\C-n":menu-complete

# ^l clear screen
bind -m vi-insert "\C-l":clear-screen

# Editor
export EDITOR=vim

# ssh host autocomplete
complete -W "$(echo $(grep '^ssh ' ~/.bash_history | sort -u | sed 's/^ssh //'))" ssh

# Create ~/tmp if it doesn't exist
if [ ! -e "$HOME/tmp" ]; then
	echo "Creating ~/tmp"
	mkdir $HOME/tmp
fi

# Add ~/bin to PATH
if [ -d "$HOME/bin" ]; then
	export PATH=$PATH:"$HOME/bin"
fi

# Add default /usr/local/bin
if [ -d "/usr/local/bin" ]; then
	export PATH="/usr/local/bin":"$PATH"
fi

# Add default /usr/local/sbin
if [ -d "/usr/local/sbin" ]; then
	export PATH="/usr/local/sbin":"$PATH"
fi

# Set p4 config if present
if [ -e "$HOME/.p4config" ]; then
	export P4CONFIG="$HOME/.p4config"
fi

# Sweet, sweet aliases
source "$HOME/.bash-aliases"

# Git branch completion and PS1 goodies
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

# Use git file listings in fzf
export FZF_DEFAULT_COMMAND='(git ls-files --recurse-submodules || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'

# Custom prompt: User@Location (current git branch)\n$
if type -t __git_ps1 | grep -q '^function$' 2>/dev/null; then
	export PS1='\[\033[0m\]\[\033[32m\]\u@\h \[\033[33m\]\w\[\033[36m\]$(__git_ps1) \[\033[0m\]$ '
else
	export PS1='\[\033[0m\]\[\033[32m\]\u@\h \[\033[33m\]\w\[\033[36m\] \[\033[0m\]$ '
fi

# Expose powerline location for tmux
export POWERLINE_PKG=`python -c "from imp import find_module; print(find_module('powerline'))[1]"`
if [ -d "$POWERLINE_PKG" ]; then
	export PATH="$PATH":$(cd "${POWERLINE_PKG}/../../../../bin"; pwd)
fi

if hash figlet 2>/dev/null; then
	figlet -f cybermedium `hostname`:`whoami`
fi
echo "--------------------------------"
echo "It is currently `date`"
echo ""
echo "Last 5 login events:"
last | head -n5 | tail -r
cowsay $(fortune -s)

# Check/source local bashrc
if [ -f "$HOME/.bashrc-local" ]; then
	source "$HOME/.bashrc-local"
fi

# Hook hub up to git
eval "$(hub alias -s)"
