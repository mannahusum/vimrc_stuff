" Beautifying Sourcecode
function! Preserve(command)
  let _s=@/
  let l = line(".")
  let c = col(".")

  execute a:command

  let @/=_s
  call cursor(l, c)
endfunction

nnoremap <localleader>_ :call Preserve("normal gg=G")<cr>
" üöäpzbm,.j = #$|~`+%"';
nnoremap <localleader>$ :call Preserve("%s/\\s\\+$//e")<cr>
nnoremap <localleader>- :call Preserve("retab")<cr>

noremap <silent> <C-s> :exec "tag " . expand('<cword>')<cr>
noremap <silent> <M-6> :e ++enc=utf-16le<cr>
noremap <silent> <M-8> :e ++enc=utf-8<cr>
noremap <silent> <M-d> :e ++ff=dos<cr>
noremap <silent> <M-u> :e ++ff=unix<cr>

if IsWindows()
  nnoremap <silent> <localleader>N :vertical botright terminal powershell<cr>
else
  nnoremap <silent> <localleader>N :vertical botright terminal sh<cr>
endif

nnoremap <localleader>f :setlocal spell spelllang=fr<cr>
nnoremap <localleader>u :setlocal spell spelllang=en_us<cr>
nnoremap <localleader>s :setlocal spell spelllang=sp<cr>
nnoremap <localleader>n :setlocal nospell<cr>
nnoremap <localleader>d :setlocal spell spelllang=de<cr>
nnoremap <localleader>p :setlocal spell spelllang=pl<cr>
nnoremap <localleader>b :setlocal spell spelllang=en_gb<cr>

nnoremap <silent> <localleader>Dg  :<C-u>Denite -buffer-name=search
  \ -no-empty grep<CR>
nnoremap <silent> <localleader>Df  :<C-u>Denite file/point file/old
  \ -sorters=sorter/rank
  \ `finddir('.git', ';') != '' ? 'file/rec/git' : 'file/rec'`
  \ file file:new<CR>
nnoremap <silent> <localleader>Dv
  \ :<C-u>Denite file/rec:`IsWindows() ? '~/vimfiles' : '~/.config/nvim'`<CR>

nnoremap <localleader>m :make<cr>
