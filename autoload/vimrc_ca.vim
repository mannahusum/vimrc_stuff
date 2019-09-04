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

function! vimrc_ca#_plugindir_run(cmd) abort
  call system('cd ' . shellescape(g:dein#plugin.path) . '; '. a:cmd)
endfunction

function! vimrc_ca#install_vimproc() abort
  if dein#tap('vimproc.vim')
    if dein#util#_is_windows()
      let l:cmd = 'tools\\update-dll-mingw'
    elseif executable('gmake')
      let l:cmd = 'gmake'
    else
      let l:cmd = 'make'
    endif
    call vimrc_ca#_plugindir_run(l:cmd)
  endif
endfunction
