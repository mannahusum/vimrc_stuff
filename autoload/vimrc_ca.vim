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

function! vimrc_ca#find_powershell() abort
  if IsWindows()
    return 'powershell'
  elseif has('unix')
    return resolve(systemlist('command -v pwsh')[0])
  endif
endfunction

function! vimrc_ca#add_languageclient_neovim() abort
  let s:statedir = expand('~/.local/state/languageclient')
  if !isdirectory(expand(s:statedir))
    call mkdir(expand(s:statedir), 'p')
  endif

  let g:LanguageClient_windowLogMessageLevel = 'Log'
  let g:LanguageClient_loggingLevel = 'DEBUG'
  let g:LanguageClient_serverStderr = expand(s:statedir . '/stderr.txt')

  if isdirectory(g:powershell_editor_services)
    set hidden

    let s:powershell = vimrc_ca#find_powershell()
    if executable(s:powershell)

      let s:pslogdir = expand(s:statedir . '/pses.log')
      if !isdirectory(expand(s:pslogdir))
          call mkdir(expand(s:pslogdir))
      endif

      let g:LanguageClient_serverCommands = {
       \ 'ps1': [
       \   s:powershell,
       \   '-ExecutionPolicy', 'Unrestricted',
       \   '-File',
       \   g:powershell_editor_services .
       \     'Start-EditorServices.ps1',
       \   '-HostName', 'nvim',
       \   '-HostProfileId', '0',
       \   '-HostVersion', '1.9.0',
       \   '-LogPath', expand(s:pslogdir . '/log.txt'),
       \   '-LogLevel', 'Diagnostic',
       \   '-BundledModulesPath', expand(g:powershell_editor_services . '/..'),
       \   '-AdditionalModules', "@('PowerShellEditorServices.VSCode')",
       \   '-Stdio',
       \   '-SessionDetailsPath', expand(s:statedir . '/pses_session')]
      \ }

    endif
  endif
endfunction
