# What is this?

Simple plugin that allows vim to enable/disable the IBus input method when entering and leaving insert mode. This is useful for non English speaking users that use other input methods to write documents in vim.

# Requirements

  - OS with DBUS support
  - IBus as input method switcher
  - Vim 7.3 with ruby interpreter support compiled in (+ruby)
  - ruby-dbus gem installed

# Features

 - Disable input methods when in normal mode.
 - Re-enable input methods when entering insert mode, only if it was previously enabled.

# Details

Refer to the [doc/vim-im.txt](doc/vim-im.txt) file for details on usage and installation of this plugin.
