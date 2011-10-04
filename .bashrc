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

# OS-specific environments
case "$_os" in
Darwin)     # Mac OS X
    # set pager
    if test -x /usr/local/bin/lv; then
        export PAGER=/usr/local/bin/lv
        export LV='-Ou8'
    else
        export PAGER=/usr/bin/less
    fi

    export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
    export PATH=/Applications/TeX/pTeX.app/teTeX/bin:$PATH
    ;;
FreeBSD)    # FreeBSD
    if [ -f /usr/local/etc/bash_completion ]; then
      . /usr/local/etc/bash_completion
    fi
    export PAGER=/usr/local/bin/lv
    export LV='-Ou8'
    export EDITOR=/usr/local/bin/vim
    ;;
esac

##
# set aliase
#
alias ..='cd ..'
alias ll='ls -lh'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias grep='grep --color=auto'
alias info="info --vi-keys"

# OS-specific aliases
case "$_os" in
Darwin)     # Mac OS X
    alias ls='/bin/ls -Gh'

    # cups
    alias start_cups='sudo launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist'
    alias stop_cups='sudo launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist'

    # vim aliases
    alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    alias gvim='open -a /Applications/MacVim.app "$@"'

    alias qlf='qlmanage -p "$@" >& /dev/null'
    ;;
FreeBSD)    # FreeBSD
    alias ls='/usr/local/bin/gnuls --color=auto -h'
    alias vi='/usr/local/bin/vim'
    alias man='env LC_ALL=ja_JP.eucJP jman'
    alias portupgrade="sudo portmaster -CKdway -x apr"
    ;;
esac

# local settings
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

#-----------
# Functions
#-----------
# i: 直前の履歴 30件を表示する。引数がある場合は過去 1000件を検索
function i {
  if [ "$1" ]; then history 1000 | grep "$@"; else history 30; fi
}

# I: 直前の履歴 30件を表示する。引数がある場合は過去のすべてを検索
function I {
  if [ "$1" ]; then history | grep "$@"; else history 30; fi
}

# GNU screen 用のコマンド。引数を screen のステータス行に表示。
function dispstatus {
  if [[ "$STY" ]]; then echo -en "\033k$1\033\134"; fi
}

# 最後のコマンドの実行時間を計測
function time_spent {
  COMTIME=$(expr $(date +%s) - ${COMTIME:=0})
}
trap 'time_spent' DEBUG

# 3秒以上処理に時間がかかったときは通知
# コマンドが正常終了しなかったときはエラーコードを出力
IGNORE_COMMANDS=('vi' 'vim' 'gvim' 'man' 'less' 'lv' 'top')
function notify-execomp {
  local s=$?
  local command="$(history 1 | awk '{s=$4;for(i=5;i<=NF;i++){s=s" "$i}print s}')"
  local message=""
  dispstatus "${PWD/${HOME}/~}"
  if [[ $s -ne 0 ]]; then
    message="\"$command\" is exit on error code $s."
  elif [[ 3 -lt $COMTIME ]]; then
    message="\"$command\" execution completed at $COMTIME sec."
    unset COMTIME

    local com="$(echo $command | awk '{print $1}')"
    for icom in "${IGNORE_COMMANDS[@]}"; do
      if [[ $icom == $com ]]; then
        return
      fi
    done
  fi

  if [[ $message != "" ]]; then
    case "$_os" in
    Darwin)
      growlnotify -n notify-execomp -t bash -m "$message"
      ;;
    *)
      echo "$message"
      ;;
    esac
  fi
}
PROMPT_COMMAND='notify-execomp'

#
# Performs an egrep on the process list. Use any arguments that egrep accetps.
#
# @param [Array] egrep arguments
case "$_os" in
  Darwin|OpenBSD) psg() { ps wwwaux | egrep "($@|\bPID\b)" | egrep -v "grep"; } ;;
  SunOS|Linux)    psg() { ps -ef | egrep "($@|\bPID\b)" | egrep -v "grep"; } ;;
  CYGWIN_*)       psg() { ps -efW | egrep "($@|\bPID\b)" | egrep -v "grep"; } ;;
esac

##
# Returns the public/internet visible IP address of the system.
#
public_ip() {
  curl 'http://vps.tokcs.com/cgi-bin/ip'
  echo -ne "\n"
}

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

