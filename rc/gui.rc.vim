
if has("gui_gtk2") || has("gui_gtk3")
  set guifont=FuraCode\ Nerd\ Font\ Mono\ 10
elseif has("gui_photon")
  set guifont=FuraCode\ Nerd\ Font\ Mono:s9
elseif has("gui_kde")
  set guifont=FuraCode\ Nerd\ Font\ Mono/9/5/50/0/0/0/1/0
elseif has("x11")
  set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
else
  set guifont=FuraCode_Nerd_Font_Mono:h8:cANSI
endif

if has('win32') || has('win64')
   set linespace=2
endif

"---------------------------------------------------------------------------
" Windows:
"
if !exists('g:columsset')
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
  set background=dark
  colorscheme blue
  if dein#tap('vim-solarized8')
    colorscheme solarized8
    set background=light
  endif

  let g:columsset=1
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
