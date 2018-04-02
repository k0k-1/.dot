"                           ..
"              __________ .:::::. __________
"             l          ]:::::::l          |
"              '|       |:::::::::'       ./
"               |       |:::::::'       ./'
"               |       |::;::'       .:.
"             .:|       |:::'        .::::.
"           .:::|       |:'        .:::::::::.
"           ':::|       '       __::::::::::'
"             ''|              /__/::::::::'__
"               |            .['''/['''v''v'  \.
"               |         .:::/  /:/  /\  /\   /
"               |       .::::/  /:/  / / / /' /
"               |     ./''::'__] /__]/___]/___]
"               '----'     '::::'
"                            ''
"               __           _
"               \ \     __ _(_)_ __
"                > >    \ V / | '  \
"               /_/      \_/|_|_|_|_|     ___
"                                        |___|

"       * file name : .vimrc
"       * auther    : kip-s
"       * url       : http://kip-s.net
"       * ver       : 3.21

"       * contents  : [1] general
"                           > var
"                           > format
"                           > indent
"                           > buffer
"                           > cursor
"                           > option
"                           > history
"                           > search

"                     [2] plugin
"                           > load plugin

"                     [3] keybinds
"                           > cursor
"                           > space
"                           > window
"                               > tab
"                               > buffer
"                           > shortcut
"                               > file-access
"                           > fuck

"                     [4] look

"                     [5] os
"                           > mac os
"                           > unix
"                           > windows 64bit
"                           > windows 32bit





" * >   [1] general
" -------------------------------------------                            /
" ----------------------------------------------------------------------/
" [

se all&

filetype off
filetype plugin indent off

se autoread
"se autochdir

se nocompatible

aug fau
    au!
aug end


" * >>  var --------------------------------------------/
" [[

" cf. sugoi-vimrc [[[[
let $home                   = expand('~')
let $vim_dir                = expand('$home/.vim')

let $myvimrc                = resolve(expand('$home/.vimrc'))

let $vim_bak                = $vim_dir . '/tmp/backup'
let $vim_undo               = $vim_dir . '/tmp/undo'
let $vim_session            = $vim_dir . '/tmp/session'
" ]]]]

" ]]
" * << -------------------------------------------------/



" * >>  format -----------------------------------------/
" [[

scriptencoding utf-8
se fileformat=unix                              " write
se fileformats=unix,dos,mac                     " read
se fileencoding=utf-8                           " write
se fileencodings=utf-8,iso-2022-jp,cp932,euc-jp " read
se termencoding=utf-8
se ambiwidth=double

" ]]
" * << -------------------------------------------------/



" * >>  indent -----------------------------------------/
" [[

se smartindent
se autoindent
se formatoptions=c
se showmatch
se smarttab

se ts=4 sw=4 et
se softtabstop=0

" ]]
" * << -------------------------------------------------/



" * >>  buffer -----------------------------------------/
" [[

se hidden
se switchbuf=useopen

" ]]
" * << -------------------------------------------------/



" * >>  cursor -----------------------------------------/
" [[

se scrolloff=999
se nostartofline
se nrformats=alpha

se backspace=2 " 2={indent,eol,start}
se virtualedit=block

" ]]
" * << -------------------------------------------------/



" * >>  option -----------------------------------------/
" [[

se ttyfast
"se foldmethod=indent
se foldmethod=manual
"se foldopen=all
"se foldclose=all
se updatetime=0
if has('mouse')
    se mouse=a
en

" ]]
" * << -------------------------------------------------/



" * >>  history ----------------------------------------/
" [[

se history=100
se viminfo=

se noswapfile

if has('persistent_undo')
    se undodir=$vim_undo
    if ! isdirectory(&undodir)
        cal mkdir(&undodir, 'p')
    en
se undofile
en

se backupdir=$vim_bak
if ! isdirectory(&backupdir)
    cal mkdir(&backupdir)
en
se backup
se writebackup

" ]]
" * << -------------------------------------------------/



" * >>  search -----------------------------------------/
" [[

se incsearch
se ignorecase
se smartcase
se wrapscan
se wildmenu
se wildmode=longest:full,full
se wildignorecase

" ]]
" * << -------------------------------------------------/

" ]





" * >   [2] plugin
" -------------------------------------------                            /
" ----------------------------------------------------------------------/
" [



if &compatible
  set nocompatible
en

let g:vimproc#download_windows_dll = 1

let s:dein_dir = $vim_dir . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
    cal system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
en

let &runtimepath = s:dein_repo_dir .",". &runtimepath

" * >>   load plugin -------------------------------------/
" [[
    let g:rc_dir    = fnamemodify(expand('<sfile>'), ':h').('/.vim/rc')
    let s:toml      = g:rc_dir . '/dein.toml'

    if dein#load_state(s:dein_dir)
        cal dein#begin(s:dein_dir, [$myvimrc, s:toml])
        cal dein#load_toml(s:toml)
        cal dein#end()
        cal dein#save_state()
    en

    if has('vim_starting') && dein#check_install()
      cal dein#install()
    en





" * >   [3] keybinds
" -------------------------------------------                            /
" ----------------------------------------------------------------------/
" [

"   cheat-sheet
"        >    key                 | >    mode
"       --------------------------+----------------
"        * map/noremap(no)        | nomal,visual
"        * nmap(nm)/nnoremap(nn)  | nomal
"        * imap(im)/inoremap(ino) | insert
"        * cmap(cm)/cnoremap(cno) | cmd
"        * vmap(vm)/vnoremap(vn)  | visual
"        * map!/noremap!(no!)     | insert,cmd

" ------------------------------------------------------/

"   prefix
"       t : window & tab
"       f : ctrlp



nn ; :
nn : ;
nn <c-c> <esc>
ino <c-c> <esc>
nn <c-c><c-c> :noh<cr>
nn <esc><esc> :noh<cr>

let mapleader="\<space>"
map <space> <leader>



" * >>  space ------------------------------------------/
" [[

map <leader>i gg=<S-g><C-o><C-o>zz
 
no <leader>v 0v$h
no <leader>d 0v$hx
no <leader>y 0v$hy
no <leader>s :%s;
map <leader>co <S-i># <ESC>
map <leader>uc ^xx<ESC>
vm <leader>co <S-i># <ESC>
vn <leader>p "0p
nn <leader>w :<c-u>write!<cr>

com! -nargs=? -complete=dir -bang CD cal s:ChangeCurrentDir('<args>', '<bang>')
fu! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    el
        exe 'lcd' . a:directory
    en
    if a:bang == ''
        pwd
    en
endf

nn <silent> <leader>cd :<c-u>CD<cr>

" ]]
" * << -------------------------------------------------/



" * >>  cursor -----------------------------------------/
" [[

nn <right> <nop>
nn <down> <nop>
nn <up> <nop>
nn <left> <nop>
ino <right> <nop>
ino <down> <nop>
ino <up> <nop>
ino <left> <nop>
ino <c-h> <left>
ino <c-j> <down>
ino <c-k> <up>
ino <c-l> <right>
nn k gk
nn j gj
vm k gk
vm j gj

" ]]
" * << -------------------------------------------------/



" * >>  window -----------------------------------------/
" [[

nn <c-w>s :sp<cr>
nn <c-w>v :vsp<cr>
nn <c-w>o :sp
nn <c-w>O :vsp
nn <c-w><c-h> :vne<cr>
nn <c-w><c-j> :bel new<cr>
nn <c-w><c-k> :new<cr>
nn <c-w><c-l> :rightb vnew<cr>
nn <c-w>e :vsp<cr>:wincmd w<cr>:e! ./<cr>
nn <c-w>E :sp<cr>:wincmd w<cr>:e! ./<cr>

nn s <nop>
nn sj <c-w>j
nn sk <c-w>k
nn sl <c-w>l
nn sh <c-w>h
nn sj <c-w>j
nn sk <c-w>k
nn sl <c-w>l
nn sh <c-w>h



" * >>>  tab ---------------------------/
" [[[

nn sn gt
nn sp gT
nn st :<c-u>tabnew<cr>
nn ss :<c-u>sp<cr>
nn sv :<c-u>vs<cr>

" ]]]
" * <<< --------------------------------/



" * >>>  buffer ------------------------/
" [[[

nn <c-b> <nop>
nn <c-b>j :bp<cr>
nn <c-b>k :bn<cr>
nn <c-b>d :bd<cr>
nn <c-b>n :new<cr>
nn <c-b>l :buffers<cr>

" ]]]
" * <<< --------------------------------/

" ]]
" * << -------------------------------------------------/



" * >>  shortcut ---------------------------------------/
" [[

se pastetoggle=<c-e>

nn <c-l><c-l> :ls<cr>
nn <c-l><c-r> :dis<cr>
nn <c-l><c-k> :map<cr>
nn <c-l><c-m> :marks<cr>
nn <c-l><c-j> :jumps<cr>
nn <c-l><c-h> :his<cr>
nn <c-l><c-u> :undolist<cr>

cno <c-a> <home>
cno <c-b> <left>
cno <c-d> <delete>
cno <c-e> <end>
cno <c-f> <right>
cno <c-n> <down>
cno <c-p> <up>



" * >>>  file access -------------------/
" [[[

nn <c-f> <nop>
nn <c-f>v :e $myvimrc<cr>

" ]]]
" * <<< --------------------------------/

" ]]
" * << -------------------------------------------------/



" * >>  fuck -------------------------------------------/
" [[

no gu <nop>
no gU <nop>
no <leader>gu gu
no <leader>gU gu

" ]]
" * << -------------------------------------------------/

" ]





" * >   [4] look
" -------------------------------------------                            /
" ----------------------------------------------------------------------/
" [

syntax enable
se t_Co=256

se notitle
se list
se listchars=tab:>-,extends:<,trail:-,eol:<
se ruler
se cursorcolumn
se cursorline
se cursorcolumn
se scrolloff=5
se number

se showcmd
se cmdheight=1
se laststatus=2
se shortmess& shortmess+=I

se hlsearch
se lazyredraw

se statusline=[%n]
se statusline& statusline+=%{matchstr(hostname(),'\\w\\+')}@
se statusline& statusline+=%<%F
se statusline& statusline+=%m
se statusline& statusline+=%r
se statusline& statusline+=%h
se statusline& statusline+=%w
se statusline& statusline+=[%{&fileformat}]
se statusline& statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
se statusline& statusline+=%y
se statusline& statusline+=%=
se statusline& statusline+=%{exists('*SkkGetModeStr')?SkkGetModeStr():''}
se statusline& statusline+=[%{col('.')-1}=ASCII=%B,HEX=%c]
se statusline& statusline+=[C=%c/%{col('$')-1}]
se statusline& statusline+=[L=%l/%L]
se statusline& statusline+=[%p%%]

" ]


" * >   [5] os
" -------------------------------------------                            /
" ----------------------------------------------------------------------/
" [

if has("mac")
" * >>  mac os -----------------------------------------/
" [[

" ]]
" * << -------------------------------------------------/



elsei has("unix")
" * >>  unix -------------------------------------------/
" [[

" ]]
" * << -------------------------------------------------/



elsei has("win64")
" * >>  windows 64bit ----------------------------------/
" [[

" ]]
" * << -------------------------------------------------/



elsei has("win32")
" * >>  windows 32bit ----------------------------------/
" [[

" ]]
" * << -------------------------------------------------/



en

" ]
