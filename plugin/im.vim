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

if has("python")
  let s:python_enabled = 1
elseif ruby#hasRubyDbus()
  let s:ruby_enabled = 1
else
  echohl error
  echo "vim-im requires vim compiled with python or ruby"
  echohl normal
  finish
endif

let g:loaded_im_plugin = 1

function! im#disable()
  if exists("s:python_enabled")
    call python#disableIm()
  elseif exists("s:ruby_enabled")
    call ruby#disableIm()
  endif
endfunction

function! im#enable()
  if exists("b:im_enabled") && b:im_enabled == 1
    if exists("s:python_enabled")
      call python#enableIm()
    elseif exists("s:ruby_enabled")
      call ruby#enableIm()
    endif
  endif
endfunction

command! ImEnable call im#enable()
command! ImDisable call im#disable()

" Disable IM input when exiting InsertMode
autocmd InsertLeave * call im#disable()
autocmd InsertEnter * call im#enable()
