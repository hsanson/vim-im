# What is this?

Simple plugin that allows vim to enable/disable the IBus input method when entering and leaving insert mode. This is useful for non English speaking users that use other input methods to write documents in vim.

# Requirements

  - OS with DBUS support.
  - IBus as input method switcher.
  - Vim 7.3 with ruby interpreter (+ruby) or python interpreter (+python).
  - Ruby dbus gem installed if you use ruby interpreter.
  - Python ibus package installed if you use python interpreter.

# Installation

Make sure your vim is 7.3 or greater and has either ruby or python compiled in. To check if it has either ruby or python run the command:

```
vim --version
```

and if you see the +ruby or +python flags then you have ruby and python compiled in respectively.

If you want to use the ruby version of the plugin install the ruby dbus gem:

```
sudo gem install ruby-dbus
```

If you prefer to use the python version install the python-ibus package:

```
sudo apt-get install python-ibus
```

Finally add the plugin to your vim using either Vundle or Pathogen:

```
Bundle 'hsanson/vim-im'
```

# Features

 - Disable input methods when in normal mode.
 - Re-enable input methods when entering insert mode, only if it was previously enabled.

# Details

Refer to the [doc/vim-im.txt](doc/vim-im.txt) file for details on usage and installation of this plugin.
