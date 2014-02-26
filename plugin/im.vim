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

if !ibus#python#enabled()
  echohl error
  echo "vim-im could not find python ibus"
  echohl normal
  finish
endif

let g:loaded_im_plugin = 1

if !exists('g:im_default_methods')
  let g:im_default_methods = {
        \ 'anthy'    :    'Latin',
        \ 'mozc-jp'  :    'Direct'
        \}
endif

function! im#disable()
  call ibus#disableIm()
endfunction

function! im#enable()
  if exists("b:im_enabled") && b:im_enabled == 1
    call ibus#enableIm()
  endif
endfunction

command! ImEnable call im#enable()
command! ImDisable call im#disable()

" Disable IM input when exiting InsertMode
autocmd InsertLeave * call im#disable()
autocmd InsertEnter * call im#enable()
