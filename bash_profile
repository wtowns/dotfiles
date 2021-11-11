# Init jenv
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

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

# Check/source local .bash_profile
if [ -f "$HOME/.bash_profile-local" ]; then
	source "$HOME/.bash_profile-local"
fi

# Use homebrew Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"

# If this is an interactive shell, run .bashrc
[[ $- == *i* ]] && . "$HOME/.bashrc"

# Sweet, sweet aliases
source "$HOME/.bash-aliases"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.bash.inc' ]; then . '$HOME/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.bash.inc' ]; then . '$HOME/google-cloud-sdk/completion.bash.inc'; fi
