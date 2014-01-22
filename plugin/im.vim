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

if !has("ruby") || version < 700
  call im#loge("vim-im require vim 7.0 with ruby compiled in")
  finish
endif

let g:loaded_im_plugin = 1

ruby << EOF

IBUS_SERVICE="org.freedesktop.IBus"
IBUS_PATH_IBUS="/org/freedesktop/IBus"
IBUS_INTERFACE_IBUS="org.freedesktop.IBus"
IBUS_INTERFACE_INPUTCONTEXT="org.freedesktop.IBus.InputContext"

def get_address
  Dir.glob(ENV['HOME'] + "/.config/ibus/bus/*").each do |file|
    File.open(file).each_line do |line|
      if /IBUS_ADDRESS=/ =~ line
        return $'.chop
      end
    end
  end
end

begin
  require "dbus"
  bus = DBus::RemoteBus.new(get_address)
  service = bus.service(IBUS_SERVICE)

  ibus = service.object(IBUS_PATH_IBUS)
  ibus.introspect
  ibus.default_iface = ibus[IBUS_INTERFACE_IBUS]
  ic_name = ibus.CurrentInputContext[0]

  @context = service.object(ic_name)
  @context.introspect
  @context.default_iface = IBUS_INTERFACE_INPUTCONTEXT
  VIM::command "let g:dbus_loaded=1"
rescue LoadError => lex
  VIM::command "silent echom \"vim-im failed to load ruby-dbus gem. Disabling plugin\""
rescue DBus::Error => dex
  VIM::command "silent echom \"vim-im failed to init dbus interface. Disabling plugin\""
rescue => ex
  VIM::command "silent echom \"vim-im : #{ex}\""
end
EOF

function! im#disable()
ruby << EOF
if ! @context.nil?
  if @context.IsEnabled[0]
    VIM::command "let b:im_enabled=1"
  else
    VIM::command "let b:im_enabled=0"
  end
  @context.Disable
end
EOF
endfunction

function! im#enable()
  if exists("b:im_enabled") && b:im_enabled == 1
    ruby @context.Enable if ! @context.nil?
  endif
endfunction

command! ImEnable call im#enable()
command! ImDisable call im#disable()

" Disable IM input when exiting InsertMode
autocmd InsertLeave * call im#disable()
autocmd InsertEnter * call im#enable()
