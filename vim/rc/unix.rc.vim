"        __           _
"        \ \     __ _(_)_ __
"         > >    \ V / | '  \
"        /_/      \_/|_|_|_|_|     ___
"                                 |___|

"       * auther    : kip-s
"       * url       : https://kip-s.net
"       * ver       : 0.02

se shell=sh
se listchars=tab:»-,extends:»,trail:-,eol:«

if has('gui_running')
  se guifont=Migu\ 1M 10
  finish
en

if exists('+termguicolors')
  se termguicolors
en

se mouse=
