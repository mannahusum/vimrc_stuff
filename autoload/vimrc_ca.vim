" vimrc functions
"

function! vimrc_ca#on_filetype() abort
  if execute('filetype') =~# 'OFF'
    " Lazy loading
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction
