function! ibus#python#enabled()
  if exists('g:ibus_python_enabled')
    return g:ibus_python_enabled
  endif

  if !has("python")
    let g:ibus_python_enabled = 0
    return g:ibus_python_enabled
  endif

python << EOF
try:
  import ibus,vim
  bus = ibus.Bus()
  vim.command("let g:ibus_python_enabled = 1")
except Exception, e:
  vim.command("let g:ibus_python_enabled = 0")
EOF

  return g:ibus_python_enabled
endfunction

function! ibus#python#enable()

  if ibus#python#version() >= 150
    echo "Function not available for ibus " . ibus#python#version()
    return
  endif

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

function! ibus#python#disable()

  if ibus#python#version() >= 150
    echo "Function not available for ibus " . ibus#python#version()
    return
  endif

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

function! ibus#python#version()
  if exists('g:ibus_version')
    return g:ibus_version
  endif

python << EOF
import ibus,vim
vim.command("let g:ibus_version = %s+0"%ibus.get_version())
EOF

  return g:ibus_version
endfunction

function! ibus#python#currentEngine()

  let g:im_current_engine = ''

  if ibus#python#version() < 150
    echo "Function not available for ibus " . ibus#version()
    return g:im_current_engine
  endif

python << EOF
try:
  import ibus,vim
  bus = ibus.Bus()
  ic = ibus.InputContext(bus, bus.current_input_contxt())
  engine = ic.get_engine()
  vim.command("let g:im_current_engine='%s'"%str(engine.name))
except Exception, e:
  print "Failed to connect to iBus"
  print e
EOF

  return g:im_current_engine
endfunction

function! ibus#python#setEngine(name)

  if ibus#python#version() < 150
    echo "Function not available for ibus " . ibus#version()
    return
  endif

python << EOF
try:
  import ibus,vim
  bus = ibus.Bus()
  ic = ibus.InputContext(bus, bus.current_input_contxt())
  name = vim.eval("a:name")
  engines = bus.get_engines_by_names([name])
  size = len(engines)
  if size <= 0:
    print "Could not find engine %s"%name
  else:
    engine = engines[0]
    ic.set_engine(engine)
except Exception, e:
  print "Failed to connect to iBus"
  print e
EOF
endfunction

function! ibus#python#listEngines()

  if ibus#python#version() < 150
    echo "Function not available for ibus " . ibus#version()
    return
  endif

  let l:engines = []

python << EOF
try:
  import ibus,dbus,vim
  bus = ibus.Bus()
  names = []
  for engine in bus.list_engines():
    names.append(str(engine.name))
  vim.command("let l:engines = %s"% names)
except Exception, e:
  print "Failed to connect to iBus"
  print e
EOF
  return l:engines
endfunction

function! ibus#python#setDefaultMode()

  if ibus#python#version() < 150
    echo "Function not available for ibus " . ibus#version()
    return
  endif

  let l:engine = ibus#python#currentEngine()

  if has_key(g:im_default_methods, l:engine)
    let l:default = g:im_default_methods[l:engine]
    call ibus#python#setInputMode(l:default)
  endif
endfunction

function! ibus#python#setInputMode(mode)

  if ibus#python#version() < 150
    echo "Function not available for ibus " . ibus#python#version()
    return
  endif

python << EOF
try:
  import ibus,dbus,vim
  bus = ibus.Bus()
  conn = bus.get_dbusconn().get_object(ibus.common.IBUS_SERVICE_IBUS, bus.current_input_contxt())
  ic = dbus.Interface(conn, dbus_interface=ibus.common.IBUS_IFACE_INPUT_CONTEXT)
  mode = vim.eval("a:mode")
  ic.PropertyActivate("InputMode." + mode, ibus.PROP_STATE_CHECKED)
except Exception, e:
  print "Failed to connect to iBus"
  print e
EOF
endfunction
