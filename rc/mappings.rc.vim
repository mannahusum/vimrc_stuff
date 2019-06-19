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
nnoremap <localleader>$ :call Preserve("%s/\s\+$//e")<cr>

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

