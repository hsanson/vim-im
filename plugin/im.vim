"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin to automagically enable/disable ibus input methods when
" switching between insert and normal mode.

if exists("g:loaded_im_plugin")
  finish
endif

if &compatible
  call im#loge("vim-im cannot run in &compatible mode")
  finish
endif

if version < 700
  echohl error
  echo "vim-im requires vim 7.0 or greater"
  echohl normal
  finish
endif

let g:loaded_im_plugin = 1

function! im#disable()
  if im#enabled()
    let b:im_enabled=1
  else
    let b:im_enabled=0
  endif
  call system('fcitx-remote -c')
endfunction

function! im#enable()
  if exists("b:im_enabled") && b:im_enabled == 1
    call system('fcitx-remote -o')
  endif
endfunction

function! im#enabled()
  return system('fcitx-remote')[0] is# '2'
endfunction

command! ImEnable call im#enable()
command! ImDisable call im#disable()

" Disable IM input when exiting InsertMode
autocmd InsertLeave * call im#disable()
autocmd InsertEnter * call im#enable()
