set ambiwidth=single

if has('win32') || has('win64')
  " For Windows.

  " set guifontwide=VL\ Gothic:h11
   " set guifontwide=Ricty:h12

   set guifont=Fira_Code:h8:cANSI:cDRAFT
  " set guifont=Courier\ New:h11
  " set guifont=VL\ Gothic:h11
  " set guifont=Consolas:h12
  " set guifont=Inconsolata:h12

  " Number of pixel lines inserted between characters.
   set linespace=2

  if has('patch-7.4.394')
    " Use DirectWrite
     "set renderoptions=type:directx
  endif
elseif has('mac')
  " For Mac.
   set guifont=Osaka－等幅:h14
else
  " For Linux.
   " set guifontwide=VL\ Gothic\ 13
   set guifont="Fira Code weight=453 10"
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
  " && dein#check_install('altercation/vim-colors-solarized')
  " Solarized
  " ---------
  let g:solarized_termcolors=256 " color depth
  let g:solarized_termtrans=0 " 1|0 background transparent
  let g:solarized_bold=1 " 1|0 show bold fonts
  let g:solarized_italic=1 " 1|0 show italic fonts
  let g:solarized_underline=1 " 1|0 show underlines
  let g:solarized_contrast="high" " normal|high|low contrast
  " normal|high|low effect on whitespace characters
  let g:solarized_visibility="high"
  set background=dark
  colorscheme solarized
endif

"---------------------------------------------------------------------------
" Options:
set mouse=
set mousemodel=

" Don't focus the window when the mouse pointer is moved.
set nomousefocus
" Hide mouse pointer on insert mode.
set mousehide

" Hide toolbar and menus.
set guioptions-=Tt
set guioptions-=m
" Scrollbar is always off.
set guioptions-=rL
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
