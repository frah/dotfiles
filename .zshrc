#######################
# shell variables
#

## lang
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LC_TIME=en_US.UTF-8

## history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt hist_ignore_all_dups # 重複があれば古いものを削除
setopt hist_ignore_space    # スペースで始まるコマンド行は削除
setopt hist_no_functions    # 関数定義コマンドを削除
setopt hist_no_store        # historyコマンドを削除
setopt hist_expand          # 補完時にヒストリを自動展開
setopt share_history        # 履歴を複数端末で共有
setopt no_hist_beep         # 履歴表示時ビープ音を消音
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history

## completion
autoload -Uz compinit; compinit -u
# 補完に使うソース
zstyle ':completion:*' completer _complete _expand _list _match _approximate _prefix
# 補完候補の色付け
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# グループ化
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
# メニューから選択
zstyle ':completion:*:default' menu select=2
# スマートケースで補完
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
# sudoでも補完
zstyle ':completion:*:sudo:*' command-path $sudo_path $path
# 補完候補キャッシュ
zstyle ':completion:*' use-cache yes
# 詳細な情報を使用
zstyle ':completion:*' varbose   yes
setopt correct              # コマンド自動訂正
setopt list_packed          # 補完候補を詰めて表示
setopt nolistbeep           # 補完時にビープ音を消音
setopt complete_in_word     # カーソル位置で補完

## expansion/globbing
setopt extended_glob        # ^(not), ~(except)などの拡張表現を有効化
setopt magic_equal_subst    # =の後でも展開する
setopt mark_dirs            # globで生成したパスがディレクトリの時末尾に/追加

## prompt
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz colors; colors
setopt prompt_subst         # PROMPT内で変数展開等を行う
setopt prompt_percent       # PROMPT内で%の置換機能を有効化
setopt transient_rprompt    # コマンド実行後右プロンプトを消去

# vcs
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' formats '[%b] (%s)'
zstyle ':vcs_info:*' actionformts '[%b|%a] (%s)'
if is-at-least 4.3.10; then
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr '+'
  zstyle ':vcs_info:*' unstagedstr '?'
  zstyle ':vcs_info:*' formats '[%u%c%b] (%s)'
  zstyle ':vcs_info:*' actionformts '[%u%c%b|%a] (%s)'
fi

function _update_vcs_info() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info
if [[ $(whoami) != "root" ]]; then
  local pcolor=green
else
  local pcolor=red
fi
PROMPT="%{%F{yellow}%}[%h]%{%F{$pcolor}%}[%n@%m] %{%F{cyan}%}%~%{%f%} %1(v|%F{magenta}%1v %f|)
%{%F{$pcolor}%}%(!.#.$)%{%f%} "
RPROMPT="%{%f%}[%D{%m/%d(%a) %H:%M}]"

## directory
setopt auto_cd      # ディレクトリ名を入力するだけで移動
setopt auto_pushd   # 移動ディレクトリ履歴を自動的にpush cd-[Tab]で補完
cdpath=(~)          # ディレクトリが見つからなかった時の検索パス
chpwd_functions=($chpwd_functions dirs) # ディレクトリスタック表示

## other
umask 022           # 新規作成ファイルのパーミッションは644
ulimit -c 0         # coreファイルを作成しない
bindkey -v          # Vim風キーバインド

autoload -Uz zmv    # 賢いmv
autoload -Uz zcalc  # 計算機

setopt long_list_jobs   # jobsでプロセスID出力
export REPORTTIME=3     # プロセスの消費時間が3秒を超えたら統計を表示

export EDITOR=vim
if type lv > /dev/null 2>&1; then
  export PAGER=lv
  export LV='-Ou8 -c -l'
else
  export PAGER=less
fi
export VIMHOME=$HOME/.vim
export TEXMFHOME=$HOME/texmf

#######################
# aliases
#
if [ -f ~/.sh_aliases ]; then
  source ~/.sh_aliases
fi

#######################
# functions
#
if [ -f ~/.sh_functions ]; then
  source ~/.sh_functions
fi

#
# Set vi mode status bar
# http://www.zsh.org/mla/users/2002/msg00108.html
#

#
# Reads until the given character has been entered.
#
readuntil () {
  typeset a
  while [ "$a" != "$1" ]
  do
    read -E -k 1 a
  done
}

#
# If the $SHOWMODE variable is set, displays the vi mode, specified by
# the $VIMODE variable, under the current command line.
# 
# Arguments:
#
#   1 (optional): Beyond normal calculations, the number of additional
#   lines to move down before printing the mode.  Defaults to zero.
#
showmode() {
  typeset movedown
  typeset row

  # Get number of lines down to print mode
  movedown=$(($(echo "$RBUFFER" | wc -l) + ${1:-0}))
  # Get current row position
  echo -n "\e[6n"
  row="${${$(readuntil R)#*\[}%;*}"
  # Are we at the bottom of the terminal?
  if [ $((row+movedown)) -gt "$LINES" ]
  then
    # Scroll terminal up one line
    echo -n "\e[1S"
    # Move cursor up one line
    echo -n "\e[1A"
  fi
  # Save cursor position
  echo -n "\e[s"
  # Move cursor to start of line $movedown lines down
  echo -n "\e[$movedown;E"
  # Change font attributes
  echo -n "\e[1m"
  # Has a mode been set?
  if [ -n "$VIMODE" ]
  then
    # Print mode line
    echo -n "-- $VIMODE -- "
  else
    # Clear mode line
    echo -n "\e[0K"
  fi
  # Restore font
  echo -n "\e[0m"
  # Restore cursor position
  echo -n "\e[u"
}

clearmode() {
  VIMODE= showmode
}

#
# Temporary function to extend built-in widgets to display mode.
#
#   1: The name of the widget.
#
#   2: The mode string.
#
#   3 (optional): Beyond normal calculations, the number of additional
#   lines to move down before printing the mode.  Defaults to zero.
#
makemodal () {
  # Create new function
  eval "$1() { zle .'$1'; ${2:+VIMODE='$2'}; showmode $3 }"

  # Create new widget
  zle -N "$1"
}

# Extend widgets
makemodal vi-add-eol           INSERT
makemodal vi-add-next          INSERT
makemodal vi-change            INSERT
makemodal vi-change-eol        INSERT
makemodal vi-change-whole-line INSERT
makemodal vi-insert            INSERT
makemodal vi-insert-bol        INSERT
makemodal vi-open-line-above   INSERT
makemodal vi-substitute        INSERT
makemodal vi-open-line-below   INSERT 1
makemodal vi-replace           REPLACE
makemodal vi-cmd-mode          NORMAL

unfunction makemodal
#
# Set vi mode status bar end
#

#######################
# source platform-dependent settings
#
# Mac OS  = darwin
# FreeBSD = freebsd
# Linux   = linux
#
local _os="$(expr $OSTYPE : "\([a-z]*\)")"
if [ -f ~/.zshrc_${_os} ]; then
  source ~/.zshrc_${_os}
fi

#######################
# source local settings
#
if [ -f ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi

