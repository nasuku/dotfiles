export EDITOR=vim
export BASH_SILENCE_DEPRECATION_WARNING=1

# PATH setup
export PATH="$HOME/.bin:$PATH"

export GOROOT=/usr/local/opt/go/libexec
#export GOPATH="$HOME/work"
export PATH=$HOME/go/bin:$PATH

# vim all the things
export EDITOR="vim"
export VISUAL="$EDITOR"

# utf-8 all the things
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_COLLATE=C

# prevent API throttling when installing/updating homebrew things
#export HOMEBREW_GITHUB_API_TOKEN=9d9f01f0d6cf2214fe951cc95f9d79872fbd5499
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha


if [ -f ~/.bash_profile.local ]; then
    source ~/.bash_profile.local
fi

if [ -f ~/.bashrc -a ! -z "$PS1" ]; then
    source ~/.bashrc
fi


complete -C /usr/local/bin/mc mc
