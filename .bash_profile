export EDITOR=vim
export BASH_SILENCE_DEPRECATION_WARNING=1

# vim all the things
export EDITOR="vim"
export VISUAL="$EDITOR"

# utf-8 all the things
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_COLLATE=C

# prevent API throttling when installing/updating homebrew things
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

export GEM_HOME="$HOME/.gem"

if [ -f ~/.bash_profile.local ]; then
    source ~/.bash_profile.local
fi

if [ -f ~/.bashrc -a ! -z "$PS1" ]; then
    source ~/.bashrc
fi
