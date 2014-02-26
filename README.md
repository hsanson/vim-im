# What is this?

Simple plugin that allows vim to enable/disable the IBus input method when entering and leaving insert mode. This is useful for non English speaking users that use other input methods to write documents in vim.

# Requirements

  - OS with DBUS support.
  - IBus as input method switcher.
  - Vim 7.3 with python interpreter (+python).
  - Python ibus package installed if you use python interpreter.

# Installation

Make sure your vim is 7.3 or greater and has python support compiled in. To check if it has python run the command:

```
vim --version
```

and if you see the +python flags then you have python compiled in.

Also make sure you have the python-ibus bindings installed:

```
sudo apt-get install python-ibus
```

Finally add the plugin to your vim using either Vundle or Pathogen:

```
Bundle 'hsanson/vim-im'
```

# Details

Refer to the [doc/vim-im.txt](doc/vim-im.txt) file for details on usage and installation of this plugin.
