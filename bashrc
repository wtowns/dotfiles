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
if hash python2 2>/dev/null; then
	export POWERLINE_PKG=`python2 -c "from imp import find_module; print(find_module('powerline'))[1]"`
else
	export POWERLINE_PKG=`python -c "from imp import find_module; print(find_module('powerline'))[1]"`
fi
if [ -d "$POWERLINE_PKG" ]; then
	export PATH="$PATH":$(cd "${POWERLINE_PKG}/../../../../bin"; pwd)
fi

# Check/source local bashrc
if [ -f "$HOME/.bashrc-local" ]; then
	source "$HOME/.bashrc-local"
fi

# MOTD
if hash figlet 2>/dev/null; then
	figlet -w 200 -f larry3d `hostname`
fi
echo "--------------------------------"
echo "It is currently `date`"
echo ""
cowsay $(fortune -s)
