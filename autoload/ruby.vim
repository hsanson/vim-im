
function! ruby#hasRubyDbus()
ruby << EOF
  begin
    require "dbus"
    return 1
  rescue
  end
  return 0
EOF
endfunction

function! s:initImContext()

ruby << EOF
require "dbus"

ibus_service="org.freedesktop.IBus"
ibus_path_ibus="/org/freedesktop/IBus"
ibus_interface_ibus="org.freedesktop.IBus"
ibus_interface_inputcontext="org.freedesktop.IBus.InputContext"

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
  bus = DBus::RemoteBus.new(get_address)
  service = bus.service(ibus_service)

  ibus = service.object(ibus_path_ibus)
  ibus.introspect
  ibus.default_iface = ibus[ibus_interface_ibus]
  ic_name = ibus.CurrentInputContext[0]

  @context = service.object(ic_name)
  @context.introspect
  @context.default_iface = ibus_interface_inputcontext
Rescue LoadError => lex
  VIM::command "silent echom \"vim-im failed to load ruby-dbus gem. Disabling plugin\""
rescue DBus::Error => dex
  VIM::command "silent echom \"vim-im failed to init dbus interface. Disabling plugin\""
rescue => ex
  VIM::command "silent echom \"vim-im : #{ex}\""
end
EOF
endfunction

function! ruby#enableIm()
  call s:initImContext()
  ruby @context.Enable if ! @context.nil?
endfunction

function! ruby#disableIm()
  call s:initImContext()
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
