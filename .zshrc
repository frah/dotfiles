#######################
# shell variables
#

## lang
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LC_TIME=en_US.UTF-8
export LC_CTYPE=ja_JP.UTF-8

## history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt hist_ignore_all_dups # 重複があれば古いものを削除
setopt hist_ignore_space    # スペースで始まるコマンド行は削除
setopt hist_no_functions    # 関数定義コマンドを削除
setopt hist_no_store        # historyコマンドを削除
setopt hist_expand          # 保管時にヒストリを自動展開
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
# メニューから洗濯
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
  zstyle ':vcs_info:*' formats '%u%c%b (%s)'
  zstyle ':vcs_info:*' actionformts '%u%c%b (%s) !%a'
fi

function _update_vcs_info() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info
PROMPT="%{%F{yellow}%}[%h]%{%F{green}%}[%n@%m] %{%F{cyan}%}%~%{%f%}
%{%f%}[%D{%m/%d(%a) %H:%M}] %{%F{green}%}%(!.#.$)%{%f%} "
RPROMPT="%1(v|%F{green}%1v%f|)"

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
alias ll='ls -lh'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias grep='grep --color=auto'
alias info='info --vi-keys'
alias lv="$PAGER"
alias vim='vi'
alias -g L="|& $PAGER"
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'

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

