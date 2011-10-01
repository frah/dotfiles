ulimit -c 0

export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export HISTCONTROL=ignoreboth

alias ..='cd ..'
alias ll='ls -lh'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias grep='grep --color=auto'
alias info="info --vi-keys"

if [ -d ~/.bashenvs ]; then
    if [ $(uname -s) = "Darwin" ]; then
        source ~/.bashenvs/*.mac
    fi
fi

#-----------
# prompt
#-----------
# def color
LIGHT_YELLOW="\[\033[1;33m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[40;1;32m\]"
LIGHT_BLUE="\[\033[1;36m\]"
DARK_RED="\[\033[2;31m\]"
DARK_GREEN="\[\033[2;32m\]"
GRAY="\[\033[40;2;37m\]"
RST_COLOR="\[\033[0m\]"

if [ $(whoami) = "root" ]; then
    pcolor=$LIGHT_RED
    dcolor=$DARK_RED
else
    pcolor=$LIGHT_GREEN
    dcolor=$DARK_GREEN
fi
DATE='\[\e[$[COLUMNS-$(echo -n " (\d \t)" | wc -c)]C\e[40;2;37m[\d \t]\e[0m\e[$[COLUMNS]D\]'
export PS1="$DATE$LIGHT_YELLOW[\!]"$pcolor"[\u"$dcolor"@"$RST_COLOR$pcolor"\h] $LIGHT_BLUE\w\n$RST_COLOR$pcolor\\\$$RST_COLOR "

