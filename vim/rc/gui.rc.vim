if has('gui_running')
"            _   _
"           | |_(_)_ __ ___ ___
"           | / / | '_ \___(_-<
"           |_\_\_| .__/   /__/
"                 |_|

"       * auther    : kip-s
"       * url       : https://kip-s.net
"       * ver       : 3.30

let s:im_windows = has('win32') || has('win64')

fu! s:ruwindows() abort
  return s:im_windows
endf

fu! s:rumac() abort
  return !s:im_windows && !has('win32unix')
    \ && (has('mac') || has('macunix') || has('gui_macvim')
    \   || (!executable('xdg-open') && system('uname') =~? '^darwin'))
endf

aug fau
    au!
aug END

se cmdheight=1

se guioptions-=m
se guioptions-=T
se guioptions-=r
se guioptions-=R
se guioptions-=l
se guioptions-=L
se guioptions-=b

se fileencoding=utf-8
se fileencodings=utf-8,iso-2022-jp,cp932,euc-jp

if has('mouse')
  se mouse=a
en

if has('multi_byte_ime')
  se iminsert=0 imsearch=0
en

" * >>  font -------------------------------------------/
" [[

" sample
"   Keep it simple, stupid.
"   <>?~`!@#$%^&*()_+--{}|[]\:";'
"   1234567890
"   恥の多い生涯を送ってきました。

se guifont=Migu_1M:h10:cSHIFTJIS
if exists('&ambiwidth')
    se ambiwidth=double
en

" ]]
" * << -------------------------------------------------/



if s:ruwindows()
  cal s:source_rc('windows.rc.vim')
elseif has('unix')
  cal s:source_rc('unix.rc.vim')
en

if s:rumac()
  se guifont=Migu_1M:h10:cANSI
en

" ]
en
