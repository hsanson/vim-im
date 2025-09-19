"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin to automagically enable/disable ibus input methods when
" switching between insert and normal mode.

if exists('g:loaded_im_plugin')
  finish
endif

if &compatible
  echohl error
  echo 'vim-im cannot run in &compatible mode'
  echohl none
  finish
endif

if v:version < 700
  echohl error
  echo 'vim-im requires vim 7.0 or greater'
  echohl none
  finish
endif

let g:loaded_im_plugin = 1

function! im#disable()
  if im#enabled()
    let b:im_enabled = 1
  else
    let b:im_enabled = 0
  endif
  silent! call system('fcitx5-remote -c 2>/dev/null')
endfunction

function! im#enable()
  if exists('b:im_enabled') && b:im_enabled == 1
    silent! call system('fcitx5-remote -o 2>/dev/null')
  endif
endfunction

function! im#enabled()
  let result = system('fcitx5-remote 2>/dev/null')
  if v:shell_error == 0 && len(result) > 0
    return result[0] is# '2'
  endif
  return 0
endfunction

function! im#start()
  if mode() ==# 'n' && im#enabled()
    call im#disable()
  endif
endfunction

command! ImEnable call im#enable()
command! ImDisable call im#disable()

" Disable IM input when exiting InsertMode
augroup vimim
  autocmd!
  autocmd VimEnter * call im#start()
  autocmd InsertLeave * call im#disable()
  autocmd InsertEnter * call im#enable()
augroup END
