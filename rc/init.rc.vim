let s:is_windows = has('win32') || has('win64')

function! IsWindows() abort
  return s:is_windows
endfunction

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if has('vim_starting') && &encoding !=# 'utf-8'
  set encoding=utf-8
endif

" Build encodings.
let &fileencodings = join([
      \ 'ucs-bom', 'utf-8', 'utf-16le', 'latin1'])

if has('multi_byte_ime')
  set iminsert=2 imsearch=2
endif

" Use English interface.
language message C

" German umlaut u
let mapleader = nr2char(0x00fc, 1)
" German umlaut o
let maplocalleader = nr2char(0x00f6, 1)

if IsWindows()
  " Exchange path separator.
  set shellslash
  if !has('nvim')
    set renderoptions=type:directx
  endif
endif

let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

if filereadable(expand('~/.secret_vimrc'))
  execute 'source' expand('~/.secret_vimrc')
endif

" Load dein.
let s:dein_dir = expand('$CACHE/dein')
      \. '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
endif
execute 'set runtimepath^=' . substitute(
    \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')

" Disable packpath
set packpath=

" Disable menu.vim
if has('gui_running')
   set guioptions=mc
endif

" Setup python
if has('nvim') && !IsWindows()
  let g:python3_host_prog = get(g:, 'python3_host_prog', "/usr/bin/python3.6")
  let g:python_host_prog = get(g:, 'python_host_prog', "/usr/bin/python2.7")
endif
