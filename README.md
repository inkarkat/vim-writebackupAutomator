WRITEBACKUP AUTOMATOR
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

Unless you use a revision control system, you have to write backups yourself.
The writebackup.vim plugin makes that a simple :WriteBackup command from
within Vim, but you still have to remember to trigger the backup. The
writebackupVersionControl.vim extension can make up for a missed backup when
you have already made changes to the buffer, but have not persisted them yet,
via :WriteBackupOfSavedOriginal. Still, wouldn't it be nice if Vim detected
that you have made backups of a file in the past, and automatically creates a
new backup - without any action on your side?

This plugin builds on the writebackup.vim and
writebackupVersionControl.vim plugins, and automatically writes a backup on
a day's first write of a file that was backed up in the past, but not yet
today.
This gives you one no-hassle, worry-free backup every day. For many
writebackup.vim use cases (like editing config files distributed all over
/etc/), this initial "good state from the past" backup is the most important
one. (And of course you can still manually trigger additional checkpoint
backups via :WriteBackup as in the past.)

USAGE
------------------------------------------------------------------------------

    Once any backup exists (you can check via :WriteBackupListVersions), a new
    backup will be written on each day when you first persist the buffer via
    :write, provided that the file has not been modified yet today. (Otherwise,
    you would not be able to undo the automatic backup via
    :WriteBackupDeleteLastBackup; the automatic backup would keep reappearing
    after each :write.) Watch out for file synchronization tools and version
    control systems that may silently update the file modification date to today
    and therefore prevent automatic backups!
    For this and other reasons, it is still a good practice to trigger backups via
    :WriteBackup yourself, and just use the writebackupAutomator plugin as a
    safety net, for those instances where you forget to backup.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-writebackupAutomator
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim writebackupAutomator*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the writebackup.vim plugin ([vimscript #1828](http://www.vim.org/scripts/script.php?script_id=1828)), version 3.00 or
  higher.
- Requires the writebackupVersionControl.vim plugin ([vimscript #1829](http://www.vim.org/scripts/script.php?script_id=1829)),
  version 3.21 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.007 or
  higher.

INTEGRATION
------------------------------------------------------------------------------

You can influence the behavior of the writebackupAutomator plugin via the
buffer-local variable b:WriteBackup. When this is 0, no automatic backup will
be done even when previous backups exist. Contrariwise, when set to 1, the
buffer will be automatically backed up even when no backups exist so far.
You can use this variable in autocmds, filetype plugins or a local vimrc to
change the backup behavior for certain file types or files in a particular
location.

IDEAS
------------------------------------------------------------------------------

- Consider b:WriteBackup = 2 to skip the file modification and identical
  backup checks.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-writebackupAutomator/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 1.11    02-Apr-2020
- Adapt to the introduction of command aborts in WriteBackupVersionControl
  version 3.21.

__YOU NEED TO UPDATE to WriteBackupVersionControl
  ([vimscript #1829](http://www.vim.org/scripts/script.php?script_id=1829)) version 3.21 or higher!__
- ENH: "Skip automatic backup; file was already modified today." message is
  annoying after each :write; Instead, give each message only once per buffer.

##### 1.10    10-Jun-2012
- Never attempt to backup when the current buffer hasn't been persisted yet, but
warn in case there are already backup files lying around.

##### 1.01    26-Feb-2012
- Rename b:writebackup to b:WriteBackup to be consistent with the other
configuration variables of the WriteBackup family, and to avoid connotation
with the built-in 'writebackup' setting.

__PLEASE UPDATE YOUR CONFIGURATION__

##### 1.00    16-Feb-2012
- First published version.

##### 0.01    10-Feb-2012
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2012-2020 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
