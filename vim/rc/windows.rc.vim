"        __           _
"        \ \     __ _(_)_ __
"         > >    \ V / | '  \
"        /_/      \_/|_|_|_|_|     ___
"                                 |___|

"       * auther    : kip-s
"       * url       : https://kip-s.net
"       * ver       : 0.02

se shellslash
 
if !has('gui_running')
  se termencoding=cp932
en

if has('gui_running')
  se rop=type:directx

  se background=dark
  color hybrid
en
