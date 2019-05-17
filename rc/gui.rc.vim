

if has('win32') || has('win64')
  " For Windows.

   set guifont=FuraCode_Nerd_Font_Mono:h8:cANSI

  " Number of pixel lines inserted between characters.
   set linespace=2

  " if has('patch-7.4.394')
    " Use DirectWrite
     " set renderoptions=type:directx
  " endif
elseif has('mac')
  " For Mac.
   set guifont=Osaka－等幅:h14
else
  " For Linux.
   " set guifontwide=VL\ Gothic\ 13
   " set guifont="FuraCode Nerd Font weight=453 10"
   set guifont="FuraCode Nerd Font Mono 9"
endif

"---------------------------------------------------------------------------
" Windows:
"
if has('win32') || has('win64')
  if &columns < 120
    " Width of window.
    set columns=120
  endif
  if &lines < 55
  " Height of window.
    set lines=55
  endif
else
  if &columns < 170
    " Width of window.
     set columns=170
  endif
  if &lines < 40
    " Height of window.
     set lines=40
  endif
endif

" Don't override colorscheme.
if !exists('g:colors_name')
  set background=dark
  colorscheme desert
  if dein#tap('vim-solarized8')
    colorscheme solarized8
    set background=light
  endif
endif

"---------------------------------------------------------------------------
" Options:
set mouse=
set mousemodel=

" Don't focus the window when the mouse pointer is moved.
set nomousefocus
" Hide mouse pointer on insert mode.
set mousehide

" Execute commands without a new window
set guioptions+=!
" Link visual mode to clipboard
set guioptions+=a
" Hide toolbar and menus.
set guioptions-=T
set guioptions-=t
set guioptions-=m
" Scrollbar is always off.
set guioptions-=r
set guioptions-=L
" Not guitablabel.
set guioptions-=e
" Confirm without window.
set guioptions+=c
" if has('patch-8.0.1609')
"   set guioptions+=!
" endif

" Don't flick cursor.
set guicursor&
set guicursor+=a:blinkon0

" display completion options on the command line
set wildmenu

" " vim: foldmethod=marker
