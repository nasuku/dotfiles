# .bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTIGNORE="&:ls:exit"
HISTCONTROL=erasedups:ignoreboth
HISTSIZE=2000
HISTFILESIZE=2000
MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH

shopt -s cdspell
shopt -s no_empty_cmd_completion
shopt -s checkhash
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s nocaseglob
shopt -s histappend

# Source everything in my .bash.d directory.
for file in "$HOME/.bash.d/"*; do
    if [ -f "$file" ]; then
        . "$file"
    fi
done
# and in my .bash.d.local
for file in "$HOME/.bash.d.local/"*; do
    if [ -f "$file" ]; then
        . "$file"
    fi
done


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# directory specific .envrc files
#eval "$(direnv hook bash)"

# Source kubectl bash completion (generated with `kubectl completion bash > ~/.kube/bash_completion`)
[ -f ~/.kube/bash_completion ] && source ~/.kube/bash_completion

# Bash completion for brew installed tools
[ -f /usr/local/bin/brew ] && source "$(brew --prefix)/etc/bash_completion"

complete -C /usr/local/bin/terraform terraform
