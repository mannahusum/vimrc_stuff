" Search

" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase
" option.
set smartcase

" Enable incremental search.
set incsearch
" Don't highlight search result.
set nohlsearch

" Searches wrap around the end of the file.
set wrapscan


" Edit

" Smart insert tab setting.
set smarttab
" Exchange tab to spaces.
set expandtab
" Substitute <Tab> with blanks.
" set tabstop=8
" Spaces instead <Tab>.
" set softtabstop=4
" Autoindent width.
set shiftwidth=4
" Round indent by shiftwidth.
set shiftround

" Enable smart indent.
set autoindent smartindent

function! GnuIndent()
  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  setlocal shiftwidth=2
  setlocal tabstop=8
  setlocal noexpandtab
endfunction

" Disable modeline.
set modelines=0
set nomodeline
autocmd MyAutoCmd BufRead,BufWritePost *.txt setlocal modelines=5 modeline

" Use clipboard register.

if 0
  if (!has('nvim') || $DISPLAY != '') && has('clipboard')
    if has('unnamedplus')
       set clipboard& clipboard+=unnamedplus
    else
       set clipboard& clipboard+=unnamed
    endif
  endif
endif

" Enable backspace delete indent and newline.
set backspace=indent,eol,start

" Highlight <>.
set matchpairs+=<:>

" Display another buffer when current buffer isn't saved.
set hidden

" Search home directory path on cd.
" But can't complete.
"  set cdpath+=~

" Enable folding.
set foldenable
set foldmethod=indent
" Show folding level.
set foldcolumn=1
set fillchars=vert:\|
set commentstring=%s

" FastFold
autocmd MyAutoCmd TextChangedI,TextChanged *
  \ if &l:foldenable && &l:foldmethod !=# 'manual' |
  \   let b:foldmethod_save = &l:foldmethod |
  \   let &l:foldmethod = 'manual' |
  \ endif
autocmd MyAutoCmd BufWritePost *
  \ if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save') |
  \   let &l:foldmethod = b:foldmethod_save |
  \   execute 'normal! zx' |
  \ endif

if exists('*FoldCCtext')
  " Use FoldCCtext().
  set foldtext=FoldCCtext()
endif

