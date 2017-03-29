" tinyとsmallではvimrcを読み込まない
if !1 | finish | endif

if &compatible
    set nocompatible
endif
filetype off

"---------------------------------------------------------------------------
" NeoBundle
"---------------------------------------------------------------------------
" neobundle.vim が無ければインストールする
if ! isdirectory(expand('~/.vim/bundle'))
    echon "Installing neobundle.vim..."
    silent call mkdir(expand('~/.vim/bundle'), 'p')
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    echo "done."
    if v:shell_error
        echoerr "neobundle.vim installation has failed!"
        finish
    endif
endif

if has('vim_starting')
    set rtp+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))

if neobundle#load_cache()
    NeoBundleFetch 'Shougo/neobundle.vim'
    NeoBundle 'Shougo/vimproc.vim', {
        \ 'build' : {
        \       'windows' : 'tools\\update-dll-mingw',
        \       'cygwin'  : 'make -f make_cygwin.mak',
        \       'mac'     : 'make',
        \       'linux'   : 'make',
        \       'unix'    : 'gmake',
        \   }
        \ }
    NeoBundle 'vim-jp/vimdoc-ja'
    NeoBundle 'vim-airline/vim-airline'
    NeoBundle 'vim-airline/vim-airline-themes'
    NeoBundle 'rhysd/accelerated-jk'
    NeoBundle 'tpope/vim-fugitive'
    NeoBundle 'kyouryuukunn/vim-changed'
    NeoBundle 'pgilad/vim-skeletons'
    NeoBundle 'kana/vim-smartword'
    NeoBundle 'thinca/vim-ref'
    NeoBundle 'thinca/vim-quickrun'
    NeoBundle 'tpope/vim-surround'
    NeoBundle 'vim-scripts/Align'
    NeoBundle 'nathanaelkane/vim-indent-guides'
    NeoBundle 'LeafCage/yankround.vim'
    NeoBundleLazy "sjl/gundo.vim", {
                \   'autoload': {
                \       'commands': ['GundoToggle']
                \ }}

    if has('unix') || has('mac')
        NeoBundle 'sudo.vim'
    endif

    " Syntax
    NeoBundle 'leafgarland/typescript-vim'
    NeoBundleLazy 'yuroyoro/vim-python', {
                \ 'autoload': {
                \   'filetypes' : ['python']}
                \ }
    NeoBundle 'Arduino-syntax-file'

    " Color schemes
    NeoBundle 'tomasr/molokai'

    " unite.vim
    NeoBundle 'Shougo/unite-outline'
    NeoBundle 'osyo-manga/unite-quickfix'
    NeoBundle 'Shougo/unite-help'
    NeoBundle 'ujihisa/unite-colorscheme'
    NeoBundle 'ujihisa/unite-locate'
    NeoBundle 'Shougo/neoyank.vim'
    NeoBundle 'Shougo/neomru.vim'
    NeoBundleLazy 'Shougo/unite.vim', {
                \ 'autoload' : {
                \     'commands' : [{'name': 'Unite', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithBufferDir', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithCursorWord', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithWithInput', 'complete' : 'customlist,unite#complete_source'}]
                \    }
                \ }
    NeoBundleLazy 'Shougo/vimfiler.vim', {
                \   'depends'  : 'Shougo/unite.vim',
                \   'autoload' : {
                \       'commands' : ['VimFiler', 'VimFilerCurrentDir',
                \                     'VimFilerBufferDir', 'VimFilerSplit',
                \                     'VimFilerExplorer', 'VimFilerDouble']
                \   }
                \ }

    " completion
    if v:version >= 703 && has('lua') && has('patch885')
        NeoBundle 'Shougo/neocomplete.vim'
    else
        NeoBundle 'Shougo/neocomplcache'
    endif
    NeoBundle 'Shougo/neosnippet.vim'
    NeoBundle 'Shougo/neosnippet-snippets'

    " python
    NeoBundleLazy 'jmcantrell/vim-virtualenv', {
                \   'autoload': {
                \       'filetypes': ['python', 'python3', 'djangohtml']
                \   }}
    NeoBundleLazy 'lambdalisue/vim-django-support', {
                \   'autoload': {
                \       'filetypes': ['python', 'python3', 'djangohtml']
                \   }}
    NeoBundleLazy 'davidhalter/jedi-vim', {
                \   'autoload': {
                \       'filetypes': ['python', 'python3', 'djangohtml']
                \   },
                \   'build': {
                \       'mac' : 'pip install jedi',
                \       'unix': 'pip install jedi'
                \   }}

    NeoBundleCheck
    NeoBundleSaveCache
endif

call neobundle#end()
filetype plugin indent on


"---------------------------------------------------------------------------
" 基本設定 Basics
"---------------------------------------------------------------------------
let mapleader = ","              " キーマップリーダー
set scrolloff=5                  " スクロール時の余白確保
set textwidth=0                  " 一行に長い文章を書いていても自動折り返しをしない
set nobackup                     " バックアップ取らない
set autoread                     " 他で書き換えられたら自動で読み直す
set noswapfile                   " スワップファイル作らない
set hidden                       " 編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set formatoptions=lmoq           " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                     " ビープをならさない
set browsedir=buffer             " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set showcmd                      " コマンドをステータス行に表示
set showmode                     " 現在のモードを表示
set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
set modelines=0                  " モードラインは無効

" OSのクリップボードを使用する
set clipboard+=unnamed

" Ev/Rvでvimrcの編集と反映
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC

set helpfile=$VIMRUNTIME/doc/help.txt

" ファイルタイプ判定をon
filetype plugin on

" augroupをまとめる
augroup VimrcLocal
    autocmd!
augroup END
command! -nargs=* Autocmd   autocmd VimrcLocal <args>
command! -nargs=* AutocmdFT autocmd VimrcLocal FileType <args>

" ファイルタイプ個別設定
Autocmd BufNewFile,BufRead *.md  set filetype=markdown
Autocmd BufNewFile,BufRead *.pde set filetype=arduino
Autocmd BufNewFile,BufRead *.ts  set filetype=typescript


"---------------------------------------------------------------------------
" ステータスライン StatusLine
"---------------------------------------------------------------------------
set laststatus=2 " 常にステータスラインを表示

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

" vim-airline
if neobundle#tap('vim-airline')
    let g:airline_theme = 'molokai'
    let g:airline#extensions#whitespace#enabled = 0
    "let g:airline#extensions#branch#enabled = 0
    "let g:airline#extensions#readonly#enabled = 0
    "let g:airline_section_b =
    "        \ '%{airline#extensions#branch#get_head()}' .
    "        \ '%{""!=airline#extensions#branch#get_head()?("  " . g:airline_left_alt_sep . " "):""}' .
    "        \ '%{airline#extensions#readonly#get_mark()}' .
    "        \ '%t%( %M%)'
    let g:airline_section_c = ''
    let s:sep = " %{get(g:, 'airline_right_alt_sep', '')} "
    let g:airline_section_x =
            \ '%{strlen(&fileformat)?&fileformat:""}'.s:sep.
            \ '%{strlen(&fenc)?&fenc:&enc}'.s:sep.
            \ '%{strlen(&filetype)?&filetype:"no ft"}'
    let g:airline_section_y = '%3p%%'
    let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v'
    let g:airline_inactive_collapse = 0

    " Use airline at tabline
    let g:airline#extensions#tabline#enabled = 1
    " （タブが一個の場合）バッファのリストをタブラインに表示する機能をオフ
    let g:airline#extensions#tabline#show_buffers = 0
    " 0でそのタブで開いてるウィンドウ数、1で左のタブから連番
    let g:airline#extensions#tabline#tab_nr_type = 1
    " タブに表示する名前（fnamemodifyの第二引数）
    let g:airline#extensions#tabline#fnamemod = ':t'
endif

"ステータスラインに文字コードと改行文字を表示する
if winwidth(0) >= 120
    set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %l,%c%V%8P
else
    set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %l,%c%V%8P
endif

"入力モード時、ステータスラインのカラーを変更
Autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340 ctermfg=cyan
Autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90 ctermfg=white

function! GetB()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    let c = iconv(c, &enc, &fenc)
    return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
    let n = a:nr
    let r = ""
    while n
        let r = '0123456789ABCDEF'[n % 16] . r
        let n = n / 16
    endwhile
    return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
    let out = ''
    let ix = 0
    while ix < strlen(a:str)
        let out = out . Nr2Hex(char2nr(a:str[ix]))
        let ix = ix + 1
    endwhile
    return out
endfunc


"---------------------------------------------------------------------------
" 表示 Apperance
"---------------------------------------------------------------------------
set showmatch         " 括弧の対応をハイライト
set number            " 行番号表示
set list              " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set display=uhex      " 印字不可能文字を16進数で表示

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" 対応括弧に'<'と'>'を追加
set matchpairs& matchpairs+=<:>

" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
Autocmd WinLeave * set nocursorline
Autocmd WinEnter,BufRead * set cursorline

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" コマンド実行中は再描画しない
:set lazyredraw
" 高速ターミナル接続を行う
:set ttyfast

" 自動的に QuickFix リストを表示する
Autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
Autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

" 最後のウィンドウがQuickFixなら自動的に閉じる
Autocmd WinEnter * call s:QuickFix_Exit_OnlyWindow()
function! s:QuickFix_Exit_OnlyWindow()
    if winnr('$') == 1 &&
                \ ((getbufvar(winbufnr(0), '&buftype')) == 'quickfix'
                \ || @% =~ 'unite-.*')
        quit
    endif
endfunction


"---------------------------------------------------------------------------
" インデント Indent
"---------------------------------------------------------------------------
set autoindent   " 自動でインデント
"set paste        " ペースト時にautoindentを無効に(onにするとautocomplpop.vimが動かない)
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set cindent      " Cプログラムファイルの自動インデントを始める

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=4 shiftwidth=4 softtabstop=0

if has("autocmd")
    "ファイルタイプの検索を有効にする
    filetype plugin on
    "そのファイルタイプにあわせたインデントを利用する
    filetype indent on
    " これらのftではインデントを無効に
    "autocmd FileType php filetype indent off

    AutocmdFT html :set indentexpr=
    AutocmdFT xhtml :set indentexpr=
endif


"---------------------------------------------------------------------------
" 補完・履歴 Complete
"---------------------------------------------------------------------------
set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=list:full     " リスト表示，最長マッチ
set history=1000           " コマンド・検索パターンの履歴数
set complete+=k            " 補完に辞書ファイル追加


"---------------------------------------------------------------------------
" タグ関連 Tags
"---------------------------------------------------------------------------
" set tags
if has("autochdir")
    " 編集しているファイルのディレクトリに自動で移動
    set autochdir
    set tags=tags;
else
    set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif


"---------------------------------------------------------------------------
" 検索設定 Search
"---------------------------------------------------------------------------
set wrapscan   " 最後まで検索したら先頭へ戻る
set ignorecase " 大文字小文字無視
set smartcase  " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索文字をハイライト
"Escの2回押しでハイライト消去
nmap <ESC><ESC> ;nohlsearch<CR><ESC>

"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap /r "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'

" Ctrl-iでヘルプ
nnoremap <C-i>  :<C-u>help<Space>
" カーソル下のキーワードをヘルプでひく
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><Enter>

" :Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>
" カーソル下の単語をGrepBufferする
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>


"---------------------------------------------------------------------------
" 移動設定 Move
"---------------------------------------------------------------------------
" カーソルキーを使用可能に
set notimeout
set ttimeout
set timeoutlen=100

" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up>   gk

" 0, 9で行頭、行末へ
nmap 1 0
nmap 0 ^
nmap 9 $

" insert mode での移動
imap  <C-e> <END>
imap  <C-a> <HOME>
" インサートモードでもhjklで移動（Ctrl押すけどね）
"imap <C-j> <Down>
"imap <C-k> <Up>
"imap <C-h> <Left>
"imap <C-l> <Right>

"<space>j, <space>kで画面送り
noremap <Space>j <C-f>
noremap <Space>k <C-b>

" spaceで次のbufferへ。back-spaceで前のbufferへ
nmap <Space><Space> ;MBEbn<CR>
nmap <BS><BS> ;MBEbp<CR>

" F2で前のバッファ
map <F2> <ESC>;bp<CR>
" F3で次のバッファ
map <F3> <ESC>;bn<CR>
" F4でバッファを削除する
map <F4> <ESC>;bw<CR>

"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" 前回終了したカーソル行に移動
Autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 最後に編集された位置に移動
nnoremap gb '[
nnoremap gp ']

" 対応する括弧に移動
nnoremap ( %
nnoremap ) %

" 最後に変更されたテキストを選択する
nnoremap gc  `[v`]
vnoremap gc <C-u>normal gc<Enter>
onoremap gc <C-u>normal gc<Enter>

" カーソル位置の単語をyankする
nnoremap vy vawy

" 矩形選択で自由に移動する
set virtualedit+=block

"ビジュアルモード時vで行末まで選択
vnoremap v $h

" CTRL-hjklでウィンドウ移動
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" git-diff-aware version of gf commands.
" http://labs.timedia.co.jp/2011/04/git-diff-aware-gf-commands-for-vim.html
nnoremap <expr> gf  <SID>do_git_diff_aware_gf('gf')
nnoremap <expr> gF  <SID>do_git_diff_aware_gf('gF')
nnoremap <expr> <C-w>f  <SID>do_git_diff_aware_gf('<C-w>f')
nnoremap <expr> <C-w><C-f>  <SID>do_git_diff_aware_gf('<C-w><C-f>')
nnoremap <expr> <C-w>F  <SID>do_git_diff_aware_gf('<C-w>F')
nnoremap <expr> <C-w>gf  <SID>do_git_diff_aware_gf('<C-w>gf')
nnoremap <expr> <C-w>gF  <SID>do_git_diff_aware_gf('<C-w>gF')

function! s:do_git_diff_aware_gf(command)
    let target_path = expand('<cfile>')
    if target_path =~# '^[ab]/'  " with a peculiar prefix of git-diff(1)?
        if filereadable(target_path) || isdirectory(target_path)
            return a:command
        else
            " BUGS: Side effect - Cursor position is changed.
            let [_, c] = searchpos('\f\+', 'cenW')
            return c . '|' . 'v' . (len(target_path) - 2 - 1) . 'h' . a:command
        endif
    else
        return a:command
    endif
endfunction

" JK高速移動
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

" tabline移動
nnoremap [Tab]   <Nop>
nmap     t       [Tab]
nmap <silent> [Tab]c    :tablast <bar> tabnew<CR>
nmap <silent> [Tab]x    :tabclose<CR>
nmap <silent> [Tab]n    :tabnext<CR>
nmap <silent> [Tab]p    :tabprevious<CR>


"---------------------------------------------------------------------------
" エンコーディング関連 Encoding
"---------------------------------------------------------------------------
set ffs=unix,dos,mac  " 改行文字
set encoding=utf-8    " デフォルトエンコーディング

" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" 文字コードの自動認識
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    Autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif

" cvsの時は文字コードをeuc-jpに設定
AutocmdFT cvs :set fileencoding=euc-jp
" 以下のファイルの時は文字コードをutf-8に設定
AutocmdFT svn :set fileencoding=utf-8
AutocmdFT js :set fileencoding=utf-8
AutocmdFT css :set fileencoding=utf-8
AutocmdFT html :set fileencoding=utf-8
AutocmdFT xml :set fileencoding=utf-8
AutocmdFT java :set fileencoding=utf-8
AutocmdFT scala :set fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932


"---------------------------------------------------------------------------
" カラー関連 Colors
"---------------------------------------------------------------------------
" ハイライト on
syntax enable

" 補完候補の色づけ for vim7
hi Pmenu ctermbg=white ctermfg=darkgray
hi PmenuSel ctermbg=blue ctermfg=white
hi PmenuSbar ctermbg=0 ctermfg=9

" カラースキーム設定
"set term=builtin_linux
"set ttytype=builtin_linux
set t_Co=256
colorscheme molokai


"---------------------------------------------------------------------------
" 編集関連 Edit
"---------------------------------------------------------------------------
" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" jjでインサートモードから抜ける
inoremap jj <ESC>

" yeでそのカーソル位置にある単語をレジスタに追加
nmap ye ;let @"=expand("<cword>")<CR>
" Visualモードでのpで選択範囲をレジスタの内容に置き換える
vnoremap p <Esc>;let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Tabキーを空白に変換
set expandtab
AutocmdFT make set noexpandtab
AutocmdFT conf set noexpandtab

" コンマの後に自動的にスペースを挿入
"inoremap , ,<Space>
" XMLの閉タグを自動挿入
AutocmdFT xml inoremap <buffer> </ </<C-x><C-o>

"  Insert mode中で単語単位/行単位の削除をアンドゥ可能にする
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>

" :Ptでインデントモード切替
command! Pt :set paste!

" y9で行末までヤンク
nmap y9 y$
" y0で行頭までヤンク
nmap y0 y^

"
" 括弧を自動補完
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
"vnoremap { "zdi^V{<C-R>z}<ESC>
"vnoremap [ "zdi^V[<C-R>z]<ESC>
"vnoremap ( "zdi^V(<C-R>z)<ESC>
"vnoremap " "zdi^V"<C-R>z^V"<ESC>
"vnoremap ' "zdi'<C-R>z'<ESC>

function! s:StripEndLineWhitespace()
    " Don't strip on these filetypes
    if &filetype =~ 'ruby\|javascript\|perl\|python'
        return
    endif
    %s/\s\+$//ge
endfunction

function! s:ExpandTab()
    " Don't expand ta on these filetypes
    if &filetype =~ 'make'
        return
    endif
    %s/\t/  /ge
endfunction

" 保存時に行末の空白を除去する
"autocmd BufWritePre * call s:StripEndLineWhitespace()
" 保存時にtabをスペースに変換する
"autocmd BufWritePre * call s:ExpandTab()

" 日時の自動入力
inoremap <expr> ,df strftime('%Y/%m/%d %H:%M:%S')
inoremap <expr> ,dd strftime('%Y/%m/%d')
inoremap <expr> ,dt strftime('%H:%M:%S')

"---------------------------------------------------------------------------
" その他 Misc
"---------------------------------------------------------------------------
" ;でコマンド入力( ;と:を入れ替)
nnoremap ; :
"nnoremap : ;

" 誤操作防止でZZ, ZQは潰す
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" exモードのマップ変更
nnoremap Q gq


"---------------------------------------------------------------------------
" プラグインごとの設定 Plugins
"---------------------------------------------------------------------------
"------------------------------------
" yankround.vim
"------------------------------------
if neobundle#tap('yankround.vim')
    nmap p      <Plug>(yankround-p)
    nmap P      <Plug>(yankround-P)
    nmap gp     <Plug>(yankround-gp)
    nmap gs     <Plug>(yankround-gP)
    " Yankの履歴参照
    nmap <C-p>  <Plug>(yankround-next)
    nmap <C-n>  <Plug>(yankround-prev)

    " 履歴取得数
    let g:yankround_max_history = 30
    " 履歴キャッシュ保存ディレクトリ
    let g:yankround_dir = '~/.cache/yankround'
endif

"------------------------------------
" vim-changed
"------------------------------------
if neobundle#tap('vim-changed')
    noremap <Leader>c   :<C-u>Changed<CR>
    " 編集後即時ハイライト
    "Autocmd InsertLeave,TextChanged * :Changed
endif

"------------------------------------
" MiniBufExplorer
"------------------------------------
"set minibfexp
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize = 10

":TmでMiniBufExplorerの表示トグル
command! Mt :TMiniBufExplorer

"------------------------------------
" Align
"------------------------------------
" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3

" ------------------------------------
" grep.vim
"------------------------------------
" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs = '.svn .git .hg'
let Grep_Skip_Files = '*.bak *~'
-

"------------------------------------
" Fugitive.vim
"------------------------------------
" The prefix key.
nnoremap [Fugitive] <Nop>
nmap     <Space>g   [Fugitive]

nnoremap [Fugitive]d :<C-u>Gdiff<Enter>
nnoremap [Fugitive]s :<C-u>Gstatus<Enter>
nnoremap [Fugitive]l :<C-u>Glog<Enter>
nnoremap [Fugitive]a :<C-u>Gwrite<Enter>
nnoremap [Fugitive]c :<C-u>Gcommit<Enter>
nnoremap [Fugitive]C :<C-u>Git commit --amend<Enter>
nnoremap [Fugitive]b :<C-u>Gblame<Enter>

"------------------------------------
" open-browser.vim
"------------------------------------
" カーソル下のURLをブラウザで開く
nmap fu <Plug>(openbrowser-open)
vmap fu <Plug>(openbrowser-open)
" カーソル下のキーワードをググる
nnoremap fs :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>

"------------------------------------
" operator-camelize.vim
"------------------------------------
" camel-caseへの変換
map <Leader>u <Plug>(operator-camelize)
map <Leader>U <Plug>(operator-decamelize)

"------------------------------------
" operator-replace.vim
"------------------------------------
" RwなどでYankしてるもので置き換える
map R <Plug>(operator-replace)

"------------------------------------
" vim-smartword
"------------------------------------
if neobundle#tap('vim-smartword')
    noremap ,w  w
    noremap ,b  b
    noremap ,e  e
    noremap ,ge  ge

    map w  <Plug>(smartword-w)
    map b  <Plug>(smartword-b)
    map e  <Plug>(smartword-e)
    map ge <Plug>(smartword-ge)
endif

"------------------------------------
" vimshell
"------------------------------------
if neobundle#tap('vimshell')
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
    let g:vimshell_enable_smart_case = 1
    let g:vimshell_temporary_directory = expand('~/.vim/.vimshell')

    if has('win32') || has('win64')
        " Display user name on Windows.
        let g:vimshell_prompt = $USERNAME."% "
    else
        " Display user name on Linux.
        let g:vimshell_prompt = $USER."% "

    "  call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
    "  call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
    "  let g:vimshell_execute_file_list['zip'] = 'zipinfo'
    "  call vimshell#set_execute_file('tgz,gz', 'gzcat')
    "  call vimshell#set_execute_file('tbz,bz2', 'bzcat')
    endif

    function! g:my_chpwd(args, context)
        call vimshell#execute('echo "chpwd"')
    endfunction
    function! g:my_emptycmd(cmdline, context)
        call vimshell#execute('echo "emptycmd"')
        return a:cmdline
    endfunction
    function! g:my_preprompt(args, context)
        call vimshell#execute('echo "preprompt"')
    endfunction
    function! g:my_preexec(cmdline, context)
        call vimshell#execute('echo "preexec"')

        if a:cmdline =~# '^\s*diff\>'
            call vimshell#set_syntax('diff')
        endif
        return a:cmdline
    endfunction

    AutocmdFT vimshell
    \ call vimshell#hook#set('chpwd', ['g:my_chpwd'])
    \| call vimshell#hook#set('emptycmd', ['g:my_emptycmd'])
    \| call vimshell#hook#set('preprompt', ['g:my_preprompt'])
    \| call vimshell#hook#set('preexec', ['g:my_preexec'])

    command! Vs :VimShell
endif

"------------------------------------
" neocomplcache.vim
"------------------------------------
if neobundle#tap('neocomplcache')
    " AutoComplPopを無効にする
    let g:acp_enableAtStartup = 0
    " NeoComplCacheを有効にする
    let g:neocomplcache_enable_at_startup = 1
    " smarrt case有効化。 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplcache_enable_smart_case = 1
    " camle caseを有効化。大文字を区切りとしたワイルドカードのように振る舞う
    let g:neocomplcache_enable_camel_case_completion = 1
    " _(アンダーバー)区切りの補完を有効化
    let g:neocomplcache_enable_underbar_completion = 1
    " シンタックスをキャッシュするときの最小文字長を3に
    let g:neocomplcache_min_syntax_length = 3
    " neocomplcacheを自動的にロックするバッファ名のパターン
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
    " -入力による候補番号の表示
    "let g:neocomplcache_enable_quick_match = 1
    " 補完候補の一番先頭を選択状態にする(AutoComplPopと似た動作)
    let g:neocomplcache_enable_auto_select = 1
    " キャッシュディレクトリを指定
    let g:neocomplcache_temporary_dir = expand('~/.vim/.neocon')
    " ctags
    if has('mac')
        let g:neocomplcache_ctags_program = '/usr/local/bin/ctags'
    endif

    " Define dictionary.
    let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'java' : $HOME.'/.vim/dict/java.dict',
    \ 'c' : $HOME.'/.vim/dict/c.dict',
    \ 'cpp' : $HOME.'/.vim/dict/cpp.dict',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'perl' : $HOME.'/.vim/dict/perl.dict',
    \ 'php' : $HOME.'/.vim/dict/php.dict',
    \ 'scheme' : $HOME.'/.vim/dict/scheme.dict',
    \ 'vm' : $HOME.'/.vim/dict/vim.dict'
    \ }

    " Define keyword.
    " if !exists('g:neocomplcache_keyword_patterns')
    " let g:neocomplcache_keyword_patterns = {}
    " endif
    " let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " ユーザー定義スニペット保存ディレクトリ
    let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'

    " スニペット
    imap <C-k> <Plug>(neocomplcache_snippets_expand)
    smap <C-k> <Plug>(neocomplcache_snippets_expand)

    " 補完を選択しpopupを閉じる
    inoremap <expr><C-y> neocomplcache#close_popup()
    " 補完をキャンセルしpopupを閉じる
    inoremap <expr><C-e> neocomplcache#cancel_popup()
    " TABで補完できるようにする
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    " undo
    inoremap <expr><C-g>     neocomplcache#undo_completion()
    " 補完候補の共通部分までを補完する
    inoremap <expr><C-l> neocomplcache#complete_common_string()
    " SuperTab like snippets behavior.
    imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
    " C-kを押すと行末まで削除
    inoremap <C-k> <C-o>D
    " C-nでneocomplcache補完
    inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
    " C-pでkeyword補完
    inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
    " 補完候補が出ていたら確定、なければ改行
    inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"

    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-x><C-o> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()

    " FileType毎のOmni補完を設定
    augroup neocomplcache
        autocmd FileType python set omnifunc=pythoncomplete#Complete
        autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
        autocmd FileType css set omnifunc=csscomplete#CompleteCSS
        autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
        autocmd FileType php set omnifunc=phpcomplete#CompletePHP
        autocmd FileType c set omnifunc=ccomplete#Complete
        autocmd FileType ruby set omnifunc=rubycomplete#Complete
    augroup END

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
endif

"------------------------------------
" neocomplete.vim
"------------------------------------
if neobundle#tap('neocomplete.vim')
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Enable omni completion.
    augroup neocomplete
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    augroup END
endif

"------------------------------------
" neosnippet.vim
"------------------------------------
if neobundle#tap('neosnippet.vim')
    " Plugin key-mappings
    imap <C-k>  <Plug>(neosnippet_expand_or_jump)
endif

"------------------------------------
" unite.vim
"------------------------------------
" The prefix key.
nnoremap [unite]   <Nop>
nmap     <Space>u  [unite]

nnoremap [unite]u  :<C-u>Unite<Space>
nnoremap <silent> [unite]a  :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]f  :<C-u>Unite -buffer-name=files file<CR>
nnoremap <silent> [unite]b  :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m  :<C-u>Unite file_mru<CR>
" grep (current buffer)
nnoremap <silent> [unite]gc :<C-u>Unite grep:% -buffer-name=unite-search -no-quit -direction=botright<CR>
" grep (current directory)
nnoremap <silent> [unite]gd :<C-u>Unite grep:. -buffer-name=unite-search<CR>
" ヤンク履歴
nnoremap <silent> [unite]y  :<C-u>Unite -buffer-name=unite-yank history/yank<CR>
" outline
nnoremap <silent> [unite]o  :<C-u>Unite -buffer-name=unite-outline outline<CR>

" nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)
    let g:unite_data_directory = expand('~/.vim/.unite')
    let g:unite_source_file_mru_limit = 200
    let g:unite_enable_start_insert = 1
    let g:unite_enable_ignore_case = 1
    let g:unite_enable_smart_case = 1

    AutocmdFT unite call s:unite_my_settings()

    function! s:unite_my_settings()
      " Overwrite settings.
      imap      <buffer> jj         <Plug>(unite_insert_leave)
      nnoremap  <silent><buffer> <Esc><Esc> :<C-q>q<CR>
      nnoremap  <silent><buffer> <C-k> :<C-u>call unite#mappings#do_action('preview')<CR>
      imap      <buffer> <C-w>      <Plug>(unite_delete_backward_path)
      nmap      <buffer> <C-n>      <Plug>(unite_select_next_line)
      nmap      <buffer> <C-p>      <Plug>(unite_select_previous_line)
    endfunction
endfunction
unlet s:bundle

"------------------------------------
" vimfiler
"------------------------------------
if neobundle#tap('vimfiler.vim')
    let g:loaded_netrwPlugin = 1
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_ignore_pattern = ['^\.git$', '^\.DS_Store$']

    let s:bundle = neobundle#get('vimfiler.vim')
    function! s:bundle.hooks.on_source(bundle)
        call vimfiler#custom#profile('default', 'context', {
            \   'edit_action' : 'tabopen',
            \   'direction'   : 'topleft'
            \ })
    endfunction
    unlet s:bundle

    nnoremap <Leader>f      <Nop>
    nnoremap <Leader>ff     :<C-u>VimFiler<CR>
    nnoremap <Leader>fs     :<C-u>VimFilerSplit -horizontal -force-hide<CR>
    nnoremap <Leader>fc     :<C-u>VimFilerCurrentDir<CR>
    nnoremap <Leader>fb     :<C-u>VimFilerBufferDir<CR>
endif

"------------------------------------
" quickrun.vim
"------------------------------------
if neobundle#tap('vim-quickrun')
    nnoremap <Leader>r  :<C-u>QuickRun -outputter quickfix<CR>
    let g:quickrun_config = {
                \   '_': {
                \       'runner': 'vimproc',
                \       'runner/vimproc/updatetime': 60,
                \       'outputter/buffer/split': ':botright',
                \       'outputter/buffer/close_on_empty': 1
                \   }
                \}
endif

"------------------------------------
" Pydiction
"------------------------------------
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'

"------------------------------------
" vim-ref
"------------------------------------
let g:ref_cache_dir = expand('~/.vim/.vim_ref_cache')
let g:ref_use_vimproc = 1
let g:ref_man_cmd = 'man'

augroup vimref
    autocmd!
    autocmd FileType sh,c nnoremap <silent> <Space>d :<C-u>call ref#jump('normal', 'man')<CR>
    autocmd FileType sh,c vnoremap <silent> <Space>d :<C-u>call ref#jump('visual', 'man')<CR>
    autocmd FileType perl nnoremap <silent> <Space>d :<C-U>call ref#jump('normal', 'perldoc')<CR>
    autocmd FileType perl vnoremap <silent> <Space>d :<C-U>call ref#jump('visual', 'perldoc')<CR>
    autocmd FileType ruby nnoremap <silent> <Space>d :<C-U>call ref#jump('normal', 'refe')<CR>
    autocmd FileType ruby vnoremap <silent> <Space>d :<C-U>call ref#jump('visual', 'refe')<CR>
    autocmd FileType python nnoremap <silent> <Space>d :<C-U>call ref#jump('normal', 'pydoc')<CR>
    autocmd FileType python vnoremap <silent> <Space>d :<C-U>call ref#jump('visual', 'pydoc')<CR>
    autocmd FileType php nnoremap <silent> <Space>d :<C-U>call ref#jump('normal', 'phpmanual')<CR>
    autocmd FileType php vnoremap <silent> <Space>d :<C-U>call ref#jump('visual', 'phpmanual')<CR>
augroup END

"------------------------------------
" Smart blockwise insertion
" http://labs.timedia.co.jp/2012/10/vim-more-useful-blockwise-insertion.html
"------------------------------------
vnoremap <expr> I  <SID>force_blockwise_visual('I')
vnoremap <expr> A  <SID>force_blockwise_visual('A')

function! s:force_blockwise_visual(next_key)
    if mode() ==# 'v'
        return "\<C-v>" . a:next_key
    elseif mode() ==# 'V'
        return "\<C-v>0o$" . a:next_key
    else  " mode() ==# "\<C-v>"
        return a:next_key
    endif
endfunction

"------------------------------------
" vim-indent-guides
"------------------------------------
if neobundle#tap('vim-indent-guides')
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    let g:indent_guides_exclude_filetypes = ['help', 'unite']
endif

"------------------------------------
" Gundo.vim
"------------------------------------
if neobundle#tap('gundo.vim')
    nnoremap <Leader>g :GundoToggle<CR>
endif

"------------------------------------
" jedi-vim
"------------------------------------
if neobundle#tap('jedi-vim')
    let s:bundle = neobundle#get('jedi-vim')
    function! s:bundle.hooks.on_source(bundle)
        " 自動設定機能をOFF
        let g:jedi#auto_vim_configuration = 0
        " 補完の最初の項目は表示しない
        let g:jedi#popup_select_first = 0
        " quickrunと被るため変更
        let g:jedi#rename_command = '<Leader>R'
        " gundoと被るため変更
        let g:jedi#goto_command = '<Leader>G'
        imap <C-p> <C-Space>
    endfunction
    unlet s:bundle
endif


