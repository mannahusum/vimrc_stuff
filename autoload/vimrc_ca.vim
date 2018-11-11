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

function vimrc_ca#_plugindir_run(cmd) abort
  call system('cd ' . shellescape(g:dein#plugin.path) . '; '. s:cmd)
endfunction

function! vimrc_ca#install_languageclient_neovim() abort
  if dein#util#_is_windows()
    let s:cmd = 'powershell install.ps1'
  else
    let s:cmd = 'bash install.sh'
  endif
  call vimrc_ca#_plugindir_run(s:cmd)
endfunction

function! vimrc_ca#install_vimproc() abort
  if dein#tap('vimproc.vim')
    if dein#util#_is_windows()
      let s:cmd = 'tools\\update-dll-mingw'
    elseif executable('gmake')
      let s:cmd = 'gmake'
    else
      let s:cmd = 'make'
    endif
    call vimrc_ca#_plugindir_run(s:cmd)
  endif
endfunction
