﻿let s:is_windows = has('win32') || has('win64')

function! IsWindows() abort
  return s:is_windows
endfunction

function! IsMac() abort
  return !s:is_windows && !has('win32unix')
      \ && (has('mac') || has('macunix') || has('gui_macvim')
      \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))
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
  set iminsert=0 imsearch=0
endif

" Use English interface.
language message C

" Use ',' instead of '\'.
" Use <Leader> in global plugin.
let mapleader = nr2char(0x00fc, 1)
" Use <LocalLeader> in filetype plugin.
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
let s:dein_dir = finddir('dein.vim', '.;')
if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
  if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
    let s:dein_dir = expand('$CACHE/dein')
          \. '/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' . substitute(
        \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif

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

let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_man               = 1
let g:loaded_matchit           = 1
let g:loaded_matchparen        = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_shada_plugin      = 1
" let g:loaded_spellfile_plugin  = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zipPlugin         = 1