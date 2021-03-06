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

# Use git file listings in fzf
export FZF_DEFAULT_COMMAND='(git ls-files --recurse-submodules || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'

# Check/source local bashrc
if [ -f "$HOME/.bashrc-local" ]; then
	source "$HOME/.bashrc-local"
fi

# Git branch completion and PS1 goodies
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

# Custom prompt: User@Location (current git branch)\n$
if type -t __git_ps1 | grep -q '^function$' 2>/dev/null; then
	export PS1='\[\033[0m\]\[\033[32m\]\u@\h \[\033[33m\]\w\[\033[36m\]$(__git_ps1) \[\033[0m\]$ '
else
	export PS1='\[\033[0m\]\[\033[32m\]\u@\h \[\033[33m\]\w\[\033[36m\] \[\033[0m\]$ '
fi

# MOTD
if hash figlet 2>/dev/null; then
	figlet -w 200 -f larry3d `hostname`
fi
echo "--------------------------------"
echo "It is currently `date`"
echo ""
cowsay $(fortune -s)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
