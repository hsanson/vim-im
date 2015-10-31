# What is this?

Simple plugin that allows vim to enable/disable the IBus input method when entering and leaving insert mode. This is useful for non English speaking users that use other input methods to write documents in vim.

# Requirements

This plugin works only with fcitx input method and depends on the fcitx-remote command line to do the heavy lifting. You must ensure you have at least two input methods configured to allow fcitx-remote to enable/disable the input method by switching between them.

# Installation

Add the plugin to your vim using either Vundle or Pathogen:

```
Bundle 'hsanson/vim-im'
```

# Details

Refer to the [doc/vim-im.txt](doc/vim-im.txt) file for details on usage and installation of this plugin.
