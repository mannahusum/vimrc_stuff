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

function! vimrc_ca#install_languageclient_neovim() abort
  if dein#util#_is_windows()
    let l:cmd = 'powershell install.ps1'
  else
    let l:cmd = 'bash install.sh'
  endif
  call vimrc_ca#_plugindir_run(l:cmd)
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

function! vimrc_ca#find_powershell() abort
  if IsWindows()
    return 'powershell'
  elseif has('unix')
    return resolve(systemlist('command -v pwsh')[0])
  endif
endfunction

function! s:get_visual_selection() abort
    let [l:line_start, l:column_start] = getpos("'<")[1:2]
    let [l:line_end, l:column_end] = getpos("'>")[1:2]
    let l:lines = getline(l:line_start, l:line_end)

    if len(l:lines) == 0
        return ''
    endif

    let l:lines[-1] = l:lines[-1][: l:column_end - (&selection == 'inclusive' ? 1 : 2)]
    let l:lines[0] = l:lines[0][l:column_start - 1:]

    return join(l:lines, "\n")
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
  let l:statedir = expand('~/.local/state/languageclient')
  if !isdirectory(expand(l:statedir))
    call mkdir(expand(l:statedir), 'p')
  endif

  let g:LanguageClient_windowLogMessageLevel = 'Log'
  let g:LanguageClient_loggingLevel = 'DEBUG'
  let g:LanguageClient_serverStderr = expand(l:statedir . '/stderr.txt')
  let g:LanguageClient_diagnosticsDisplay = {
    \ 1: {
    \   "name": "Error",
    \   "texthl": "SpellBad",
    \   "signText": emoji#for('heavy_multiplication_x'),
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
  " let g:LanguageClient_diagnosticsList = "Quickfix"
  " let g:LanguageClient_diagnosticsList = "Disabled"
  let g:LanguageClient_diagnosticsList = "Location"
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

    let l:powershell = vimrc_ca#find_powershell()
    if executable(l:powershell)

      let l:pslogdir = expand(l:statedir . '/pses.log')
      if !isdirectory(expand(l:pslogdir))
          call mkdir(expand(l:pslogdir))
      endif

      let g:LanguageClient_serverCommands = {
       \ 'ps1': [
       \   l:powershell,
       \   '-ExecutionPolicy', 'Unrestricted',
       \   '-File',
       \   g:powershell_editor_services .
       \     'Start-EditorServices.ps1',
       \   '-HostName', 'nvim',
       \   '-HostProfileId', '0',
       \   '-HostVersion', '1.9.0',
       \   '-LogPath', expand(l:pslogdir . '/log.txt'),
       \   '-LogLevel', 'Diagnostic',
       \   '-BundledModulesPath', expand(g:powershell_editor_services . '/..'),
       \   '-AdditionalModules', "@('PowerShellEditorServices.VSCode')",
       \   '-Stdio',
       \   '-SessionDetailsPath', expand(l:statedir . '/pses_session')]
      \ }

    endif
  endif
endfunction

function! vimrc_ca#keybindings_ps1() abort
  " setlocal errorformat="%EIn\ %f:%l\ Zeichen:%c,%.%#,%Z%\\W%#+%\\W%#CategoryInfo%\\W%#:%\\W%#%m"
  " Rename - rn => rename
  noremap <buffer> <leader>rn :call LanguageClient#textDocument_rename()<CR>

  " Rename - rm => rename camelCase
  noremap <buffer> <leader>rm :call LanguageClient#textDocument_rename(
    \ {'newName': Abolish.mixedcase(expand('<cword>'))})<CR>

  nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
  " codepage 65001 = UTF8
  let &l:keywordprg = 'chcp 65001 '
    \ . '& ' . vimrc_ca#find_powershell() . ' -c Get-Help'
  nnoremap <buffer> <C-k><C-r> :call LanguageClient_textDocument_references()<CR>

  setlocal formatexpr=LanguageClient_textDocument_rangeFormatting()
  vnoremap <buffer> = :call LanguageClient_textDocument_rangeFormatting()<CR>
  nnoremap <buffer> <C-e><C-d> :call LanguageClient_textDocument_formatting()<CR>
  vnoremap <buffer> <silent> <F8> :call vimrc_ca#langclient_evaluate()<CR>

  augroup LanguageClient_ps1
    autocmd! CursorHold *.ps1 call LanguageClient_textDocument_hover()
    autocmd! VimEnter *.ps1 :LanguageClientStart
    autocmd! VimLeave *.ps1 :LanguageClientStop
  augroup END
endfunction

function! vimrc_ca#special_K(count, keyword) abort
  let l:result=''
  if &keywordprg == ''
    execute 'vertical botright help ' . a:keyword
  elseif &keywordprg =~ "^:"
    execute 'vertical botright ' . (a:count?a:count:'') . &keywordprg . ' ' . a:keyword
  elseif &keywordprg == "man"
    let l:result = system(&keywordprg . ' ' . (a:count?a:count:'') . ' ' . a:keyword)
  elseif &keywordprg == "man -s"
    let l:result = system(&keywordprg . ' ' . a:count . ' ' . a:keyword)
  else
    let l:result = system(&keywordprg . ' ' . a:keyword)
  endif

  if l:result != ''
    botright vnew
    setlocal fileencoding=utf8
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    put =l:result
    setlocal nomodifiable
    norm gg
  endif
endfunction

nnoremap <silent> K :<C-U>call vimrc_ca#special_K(v:count,expand('<cword>'))<CR>
