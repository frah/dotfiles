umask 022   # 新規作成ファイルのパーミッションは644
set -o vi   # viキーバインド
ulimit -c 0 # coreファイルを作成しない

_os="$(uname -s)"

shopt -s checkwinsize   # 毎回ウインドウサイズをチェック
shopt -s histappend     # historyは追記で
shopt -s histreedit     # historyの再編集可能
shopt -s checkhash      # ハッシュの存在チェック
shopt -s dotglob        # .で始まるファイルもパス名展開対象に
shopt -s extglob        # 拡張正規表現を有効化
shopt -s cdspell        # cdコマンドの誤り訂正有効化
shopt -s no_empty_cmd_completion # 何も入力していないときはコマンド名補完をOFF

##
# 設定用の関数
#
# set_alias(alias_name, values): コマンドの存在をチェックした上でaliasを追加
function set_alias {
    local IFS="$IFS"
    local name="$1"
    local source="$2"
    local command=""

    IFS=" "
    set -- ${source}
    if test "$1" = "env"; then
        command="$3"
    else
        command="$1"
    fi

    if test -x "${command}"; then
        alias ${name}="${source}"
        return 0
    else
        echo "\"${command}\" is not found or executable." >&2
        return 1
    fi
}

# set_env(env_name, values): ファイルの存在をチェックした上で環境変数を更新
function set_env {
    local IFS="$IFS"
    local name="$1"
    local source="$2"

    IFS=":"
    set -- ${source}

    if test -e "$1"; then
        export ${name}="${source}"
        return 0
    else
        echo "\"$1\" is not found." >&2
        return 1
    fi
}

##
# set environment
#
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export HISTSIZE=1000
export HISTFILESIZE=99999
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTIGNORE="[ ]*:&:bg:fg:ls -l:ls -al:ls -la:ll:la:ls"
export HISTCONTROL=ignoreboth
export VIMHOME=$HOME/.vim
export TEXMFHOME=$HOME/texmf

# git settings
if [ -f ~/dotfiles/git-completion.bash ]; then
    . ~/dotfiles/git-completion.bash
fi
if [ -f ~/dotfiles/git-prompt.sh ]; then
    . ~/dotfiles/git-prompt.sh
fi
export GIT_PS1_SHOWUNTRACKEDFILES="yes"
export GIT_PS1_SHOWSTASHSTATE="yes"
export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_SHOWUPSTREAM="auto"

# OS-specific environments
case "$_os" in
Darwin)     # Mac OS X
    # set pager
    if set_env PAGER /usr/local/bin/lv; then
        export LV='-Ou8 -c'
    else
        export PAGER=/usr/bin/less
        export LESS='-R'
    fi

    set_env EDITOR /Applications/MacVim.app/Contents/MacOS/Vim
    set_env PATH /Applications/TeX/pTeX.app/teTeX/bin:$PATH
    ;;
FreeBSD)    # FreeBSD
    if [ -f /usr/local/etc/bash_completion ]; then
      . /usr/local/etc/bash_completion
    fi

    if set_env PAGER /usr/local/bin/lv; then
        export LV='-Ou8 -c'
    fi

    set_env EDITOR /usr/local/bin/vim
    ;;
esac

##
# set aliases
#
if [ -f ~/.sh_aliases ]; then
  . ~/.sh_aliases
fi

# OS-specific aliases
case "$_os" in
Darwin)     # Mac OS X
    alias ls='/bin/ls -Gh'

    # cups
    alias start_cups='sudo launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist'
    alias stop_cups='sudo launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist'

    # vim aliases
    if [ -e /Applications/MacVim.app ]; then
        alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
        alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
        alias gvim='open -a /Applications/MacVim.app "$@"'
    fi

    alias qlf='qlmanage -p "$@" >& /dev/null'
    ;;
FreeBSD)    # FreeBSD
    if ! set_alias ls '/usr/local/bin/gnuls --color=auto -h'; then
        alias ls='ls -Gh'
    fi

    set_alias vi '/usr/local/bin/vim'
    set_alias man 'env LC_ALL=ja_JP.eucJP /usr/local/bin/jman'
    alias portupgrade="sudo portmaster -CKdway -x apr"
    ;;
esac

##
# completion settings
#
complete -d cd
complete -c man
complete -v unset

# local settings
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

#-----------
# Functions
#-----------
if [ -f ~/.sh_functions ]; then
  source ~/.sh_functions
fi

function md2html {
    kramdown -i markdown ${1} > ${1%.*}.html
}


#-----------
# prompt
#-----------
# def color
LIGHT_YELLOW="\[\033[1;33m\]"
LIGHT_RED="\[\033[40;1;31m\]"
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
export PS1="$LIGHT_YELLOW[\!]$pcolor[\u$dcolor@$RST_COLOR$pcolor\h] $LIGHT_BLUE\w$LIGHT_YELLOW"'$(__git_ps1)'"\n$RST_COLOR$pcolor\\\$$RST_COLOR "

