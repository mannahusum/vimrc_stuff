" dein configurations.

let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = 1
let g:dein#install_log_filename = '~/dein.log'

let s:path = expand('$CACHE/dein')
if !dein#load_state(s:path)
  finish
endif

call dein#begin(s:path, expand('<sfile>'))

call dein#load_toml(g:vimdir . '/rc/dein.toml', {'lazy': 0})
call dein#load_toml(g:vimdir . '/rc/deinlazy.toml', {'lazy' : 1})
call dein#load_toml(g:vimdir . '/rc/deinft.toml')

let s:vimrc_local = findfile('vimrc_local.vim', '.;')
if s:vimrc_local !=# ''
  " Load develop version plugins.
  call dein#local(fnamemodify(s:vimrc_local, ':h'),
       \ {'frozen': 1, 'merged': 0},
       \ ['deoplete-*', '*.nvim'])
endif

if IsWindows()
  let s:syncplicitydir = substitute(system('for /f "tokens=3" %a in (''reg query "HKCU\Software\Classes\CLSID\{b8debcc1-b8f5-4129-8599-6b54b747daf9}\Instance\InitPropertyBag"  /V TargetFolderPath'') do echo %a'), '[\n[:space:]]*$', '', '')
  let s:plugin_dir = s:syncplicitydir . 'Documents\vim_plugins'
  if isdirectory(expand(s:plugin_dir))
    call dein#local(expand(s:plugin_dir), {'frozen': 1})
  endif
endif

" if dein#tap('deoplete.nvim') && has('nvim')
"   call dein#disable('neocomplete.vim')
" endif
call dein#disable('neobundle.vim')
call dein#disable('neopairs.vim')

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
