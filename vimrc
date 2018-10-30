" profile start profile.txt
" profile file ~/vimfiles/rc/*
if 1
  execute 'source' fnamemodify(expand('<sfile>'), ':h').'/rc/vimrc'
endif
