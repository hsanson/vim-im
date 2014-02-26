function! ibus#version()
  return ibus#python#version()
endfunction

function! ibus#enableIm()
  call ibus#python#enable()
endfunction

function! ibus#disableIm()
  if ibus#version() < 150
    call ibus#python#disable()
  else
    call ibus#setDefaultMode()
  endif
endfunction

function! ibus#setDefaultMode()
  call ibus#python#setDefaultMode()
endfunction
