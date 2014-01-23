function! python#enableIm()
python << EOF
try:
  import ibus,vim
  bus = ibus.Bus()
  ic = ibus.InputContext(bus, bus.current_input_contxt())
  if not ic.is_enabled():
    ic.enable()
except Exception, e:
  print ""
EOF
endfunction

function! python#disableIm()
python << EOF
try:
  import ibus,vim
  bus = ibus.Bus()
  ic = ibus.InputContext(bus, bus.current_input_contxt())
  if ic.is_enabled():
    vim.command("let b:im_enabled=1")
  else:
    vim.command("let b:im_enabled=0")
  ic.disable()
except Exception, e:
  print ""
EOF
endfunction
