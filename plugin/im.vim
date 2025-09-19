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

" Detect operating system
function! s:get_os()
  if has('macunix') || has('mac')
    return 'mac'
  elseif has('unix')
    return 'linux'
  elseif has('win32') || has('win64')
    return 'windows'
  endif
  return 'unknown'
endfunction

let s:os = s:get_os()

function! im#disable()
  if im#enabled()
    let b:im_enabled = 1
  else
    let b:im_enabled = 0
  endif
  
  if s:os ==# 'mac'
    " Use im-select for macOS (requires: brew install im-select)
    if executable('im-select')
      silent! call system('im-select com.apple.keylayout.US')
    else
      " Fallback to osascript
      silent! call system('osascript -e "tell application \"System Events\" to key code 0 using {control down}"')
    endif
  elseif s:os ==# 'linux'
    silent! call system('fcitx5-remote -c 2>/dev/null')
  endif
endfunction

function! im#enable()
  if exists('b:im_enabled') && b:im_enabled == 1
    if s:os ==# 'mac'
      " Use im-select for macOS
      if executable('im-select') && exists('b:im_method')
        silent! call system('im-select ' . b:im_method)
      endif
    elseif s:os ==# 'linux'
      silent! call system('fcitx5-remote -o 2>/dev/null')
    endif
  endif
endfunction

function! im#enabled()
  if s:os ==# 'mac'
    if executable('im-select')
      let result = system('im-select')
      if v:shell_error == 0 && len(result) > 0
        let b:im_method = trim(result)
        return result !~# 'com\.apple\.keylayout\.US'
      endif
    endif
    return 0
  elseif s:os ==# 'linux'
    let result = system('fcitx5-remote 2>/dev/null')
    if v:shell_error == 0 && len(result) > 0
      return result[0] is# '2'
    endif
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
