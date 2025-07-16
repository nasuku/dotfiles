export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fpath=(/usr/local/share/zsh-completions $fpath)
# Append history as commands are executed
#setopt inc_append_history
# Don't save duplicates
setopt hist_ignore_all_dups
setopt histreduceblanks
setopt histsavenodups
# Treat #, ~, and ^ as part of patterns for filename generation
setopt extended_glob

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ${HOMEBREW_PREFIX}/opt/zinit/zinit.zsh
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit snippet OMZP::aws


### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# User configuration
export HISTIGNORE="&:ls:exit"

export PATH="$HOME/.bin:$HOME/go/bin:$PATH"
export EDITOR="vim"
export VISUAL="$EDITOR"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_COLLATE=C
export MANPATH=$HOMEBREW_PREFIX/share/man:$MANPATH
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export RIPGREP_CONFIG_PATH=~/.ripgreprc

export LSCOLORS=GxFxCxDxCxegedabagaced

load_files() {
    declare -a FILES=(
        /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        #${HOME}/.zsh.d
        #${HOME}/.allsh.d # both for zsh and bash
        #${HOME}/.allsh.d.local # both for zsh and bash
        #${HOME}/.zsh.d.local
    )

    for x in "${FILES[@]}"; do
        [[ -f "$x" ]] && source "$x"
        [[ -d "$x" ]] && { for i in "${x}"/*; do source $i; done }
    done
}
load_files
unset load_files


autoload -U +X bashcompinit && bashcompinit
if type brew &>/dev/null; then
    FPATH=${HOMEBREW_PREFIX}/share/zsh-completions:$FPATH:${HOMEBREW_PREFIX}/share/zsh/site-functions
    autoload -Uz compinit
    compinit
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

bindkey "^[[A" up-line-or-search
bindkey "^[[B" down-line-or-search

#WORDCHARS remove / so that navigation stops at /
WORDCHARS="${WORDCHARS/\//}"

:<<COMMENT
❯ dy help
"get time for a city" "dig mumbai.time @dns.toys"
"convert currency rates" "dig 99USD-INR.fx @dns.toys"
"get your host's requesting IP." "dig ip @dns.toys"
"get weather forecast for a city." "dig berlin.weather @dns.toys"
"convert between units." "dig 42km-cm.unit @dns.toys"
"convert numbers to words." "dig 123456.words @dns.toys"
"convert cidr to ip range." "dig 10.100.0.0/24.cidr @dns.toys"
"return digits of Pi as TXT or A or AAAA record." "dig pi @dns.toys"
"convert numbers from one base to another" "dig 100dec-hex.base @dns.toys"
"get the definition of an English word, powered by WordNet(R)." "dig fun.dict @dns.toys"
"roll dice" "dig 1d6.dice @dns.toys"
"generate random numbers" "dig 3d20+3.dice @dns.toys"
"toss coin" "dig 2.coin @dns.toys"
"convert epoch / UNIX time to human readable time." "dig 784783800.epoch @dns.toys"
"get aerial distance between lat lng pair" "dig A12.9352,77.6245/12.9698,77.7500.aerial @dns.toys"
COMMENT
alias dy='dig +short @dns.toys'

alias ssh='ssh -oUserKnownHostsFile=/dev/null -o StrictHostKeyChecking=false'
alias scp='scp -oUserKnownHostsFile=/dev/null -o StrictHostKeyChecking=false'
alias ta='tmux -q has-session -t suresh > /dev/null 2>&1 && tmux attach-session -d -t suresh || tmux new-session -s suresh'
case `uname` in
Darwin)
    alias flushdns='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed'
    ;;
Linux)
    alias psl='ps -eLo stat,pid,lwp,user,comm,command'
    ;;
esac

alias cat=bat
alias d=docker
alias g='rg -i.'
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias hd='hexdump -C'
alias k=kubectl
alias kctx=kubectx
alias kns=kubens
alias ls='ls --color=auto'
alias l='ls -Frty'
alias ll='ls -alFrty'
alias t=task
alias v=nvim
alias vi=nvim
alias vim=nvim
alias make='nice -n 5 make -j10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# little rare stuff...
#
e2date() {
    local result=$1
    if [[ $result -gt 10000000000 ]]
    then
        gdate -d @${result%???}
    else
        gdate -d @${result}
    fi
}

# this python script is a poor man's replacement for realpath
lpwd() {
    rel=$1
    if [ $# -eq 0 ]
    then
         python3 -c "import os; print(os.path.realpath('.'))"
    else
         python3 -c "import os; print(os.path.realpath('$1'))"
    fi
}

# convert pdf to small and archive standard
pdfsma() {
    gs -dCompatibilityLevel=1.6 -dPDFA=2 -dPDFACompatibilityPolicy=1 -sColorConversionStrategy=RGB -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=out-$1 $1
}

# archival standard for pdf with all fonts embedded and better color quality but larger file size
pdfarch() {
    gs -sDEVICE=pdfwrite -dBATCH -dNOPAUSE -dSAFER -sColorConversionStrategy=UseDeviceIndependentColor -dCompatibilityLevel=1.6 -dPrinted=true -dPDFA=2 -sProcessColorModel=DeviceRGB -dPDFACompatibilityPolicy=1 -dDetectDuplicateImages -dFastWebView=true -dSubsetFonts=true -sOutputFile=out-$1 $1
}

function get_alias() {
  eval "set -- $(alias -- "$1")"
  eval 'printf "%s\n" "${'"$#"'#*=}"'
}

function join_by() { local IFS="$1"; shift; echo "$*"; }

:<<'COMMENT'
# get paranthesised group value matching regex
❯ echo 'p asq2bsas' | regex 'a(s.*)(a.)'
asq2bsas
❯ echo 'p asq2bsas' | regex 'a(s.*)(a.)' 1
sq2bs
❯ echo 'p asq2bsas' | regex 'a(s.*)(a.)' 2
as
COMMENT
function regex { gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'; }


# Simple calculator
function calc() {
        local result=""
        result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
        #                       └─ default (when `--mathlib` is used) is 20
        #
        if [[ "$result" == *.* ]]; then
                # improve the output for decimal numbers
                printf "$result" |
                sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
                    -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
                    -e 's/0*$//;s/\.$//'   # remove trailing zeros
        else
                printf "$result"
        fi
        printf "\n"
}

# convert a ps to that it can use the pocketmod folding format
pocketmod () {
    pstops '8:7,0,1,2,5,6,3,4' $1 | psnup -2 |pstops '2:0,1U(1w,1h)'| psnup -2 | psnup -2 > /tmp/1.ps
}

#print a pdf like a book
pdfbookprint () {
    pdftops $1 - | psbook |psnup -2 -pletter |pstops '2:0,1U@1(21.6cm,28cm)' |lpr ;
}

# create animated gif to cut-n-paste to github easily
# try calling like: agif in.mov out.gif
# https://gist.github.com/joyrexus/7042973
agif() {
    ffmpeg -i $1  -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $2.gif
}



source <(fzf --zsh)
eval "$(mise activate zsh)"
# (( RANDOM%20 == 0 )) &&  some-inspiring-command || true

# Tell vim that this is a shell script
# vi:set ft=sh:
