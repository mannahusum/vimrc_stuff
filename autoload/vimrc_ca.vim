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

function! s:get_visual_selection() abort
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)

    if len(lines) == 0
        return ''
    endif

    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    return join(lines, "\n")
endfunction

function! vimrc_ca#PS1OutputHandle(output) abort
  echomsg json_encode(a:output)
endfunction

function! vimrc_ca#langclient_evaluate() abort
  :call LanguageClient#Call(
    \ "evaluate",
    \ { 'expression': s:get_visual_selection() },
    \ function("vimrc_ca#PS1OutputHandle")
  \ )
endfunction

function! vimrc_ca#add_languageclient_neovim() abort
  let s:statedir = expand('~/.local/state/languageclient')
  if !isdirectory(expand(s:statedir))
    call mkdir(expand(s:statedir), 'p')
  endif

  let g:LanguageClient_windowLogMessageLevel = 'Log'
  let g:LanguageClient_loggingLevel = 'DEBUG'
  let g:LanguageClient_serverStderr = expand(s:statedir . '/stderr.txt')
  let g:LanguageClient_diagnosticsDisplay = {
    \ 1: {
    \   "name": "Error",
    \   "texthl": "SpellBad",
    \   "signText": emoji#for('heavy_multiplication'),
    \   "signTexthl": "error",
    \ },
    \ 2: {
    \   "name": "Warning",
    \   "texthl": "SpellCap",
    \   "signText": emoji#for('warning'),
    \   "signTexthl": "todo",
    \ },
    \ 3: {
    \   "name": "Information",
    \   "texthl": "SpellCap",
    \   "signText": emoji#for('information_source'),
    \   "signTexthl": "todo",
    \ },
    \ 4: {
    \   "name": "Hint",
    \   "texthl": "SpellCap",
    \   "signText": nr2char(0x27A4, 1),
    \   "signTexthl": "todo",
    \ },
  \ }
  let g:LanguageClient_diagnosticsList = "Quickfix" 
  let g:LanguageClient_documentHighlightDisplay = {
    \ 1: {
    \   "name": "Text",
    \   "texthl": "SpellCap",
    \ },
    \ 2: {
    \   "name": "Read",
    \   "texthl": "SpellLocal",
    \ },
    \ 3: {
    \   "name": "Write",
    \   "texthl": "SpellRare",
    \ },
  \ }

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

function! vimrc_ca#keybindings_ps1() abort
  " Rename - rn => rename
  noremap <leader>rn :call LanguageClient#textDocument_rename()<CR>

  " Rename - rm => rename camelCase
  noremap <leader>rm :call LanguageClient#textDocument_rename(
    \ {'newName': Abolish.mixedcase(expand('<cword>'))})<CR>

  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
  let &keywordprg = vimrc_ca#find_powershell() . ' -c Get-Help'
  nnoremap <C-k><C-r> :call LanguageClient_textDocument_references()<CR>

  set formatexpr=LanguageClient_textDocument_rangeFormatting()
  vnoremap = :call LanguageClient_textDocument_rangeFormatting()<CR>
  nnoremap <C-e><C-d> :call LanguageClient_textDocument_formatting()<CR>
  autocmd! CursorHold * call LanguageClient_textDocument_hover()

  autocmd! VimLeave * :LanguageClientStop
endfunction
