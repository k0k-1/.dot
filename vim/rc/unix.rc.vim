"            _   _
"           | |_(_)_ __ ___ ___
"           | / / | '_ \___(_-<
"           |_\_\_| .__/   /__/
"                 |_|

"       * auther    : kip-s
"       * url       : https://kip-s.net
"       * ver       : 0.01

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
