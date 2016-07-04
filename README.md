# vimrc_stuff

My current vim-config — The shared stuff


I want to use the same vim configuration on machines in different networks.
My vimrc is quite messy, but it gets the job done.

This is the current status of the shared config.


# Usage

Add following lines to your vimrc

```
let g:vimdir="~/.vim/"
exec "source " . g:vimdir . "generalvimrc"
```
