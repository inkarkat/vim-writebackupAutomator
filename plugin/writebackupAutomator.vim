" writebackupAutomator.vim: writebackup plugin automatically writes a backup on
" the first write. 
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 
"   - writebackup plugin (vimscript #1828). 
"   - writebackupVersionControl plugin (vimscript #1829). 

" Copyright: (C) 2012 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	10-Feb-2012	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_writebackupAutomator') || (v:version < 700)
    finish
endif
let g:loaded_writebackupAutomator = 1

"- functions ------------------------------------------------------------------

function! s:InterceptWrite()
    " Note: Need to use <afile> instead of % to capture the filename the buffer
    " is written to. Otherwise, :WriteBackup writes would mistakenly trigger
    " this function. 
    let l:filespec = expand('<afile>')

    if ! writebackupVersionControl#IsOriginalFile(l:filespec)
	" No backup of backup files. 
	return
    endif

    let l:backupFiles = writebackupVersionControl#GetAllBackupsForFile(l:filespec)
    if empty(l:backupFiles)
	" No backups exist. Unless the buffer has been flagged, do not perform a
	" backup. 
	if ! exists('b:writebackup') || ! b:writebackup
	    return
	endif
    else
	let l:lastBackupDate = writebackupVersionControl#GetVersion(l:backupFiles[-1])[0:-2]
	let l:today = strftime('%Y%m%d')

	if l:lastBackupDate ==# l:today
	    " Today, a backup was already made. 
	    return
	elseif l:lastBackupDate ># l:today
	    let v:warningmsg = 'The last backup was done in the future?!'
	    echohl WarningMsg
	    echomsg v:warningmsg
	    echohl None

	    return
	endif
    endif

    let l:backupStatus = writebackupVersionControl#WriteBackupOfSavedOriginal(l:filespec, 0)
    if l:backupStatus == 0
	" File is already backed up; nothing to do. 
    else
	" An error occurred, or the writing of the backup file was successful. 
	" WriteBackupVersionControl has already printed a corresponding status
	" message, but it'll soon be overwritten by the status message of the
	" impending :write command. 
	if l:backupStatus == 1
	    " As it's cumbersome to get the backup filespec from
	    " WriteBackupVersionControl, we re-create it here ourselves. 
	    let l:message = printf('Automatically backed up as "%s.%sa"',
	    \	writebackup#AdjustFilespecForBackupDir(l:filespec, 1),
	    \	l:today
	    \)
	elseif l:backupStatus == -1
	    " Reuse the error message from WriteBackupVersionControl. 
	    let l:message = v:errmsg
	endif

	" To ensure that the message is visible to the user, print it via a
	" fire-once autocmd _after_ the original buffer is written. 
	augroup writebackupAutomatorNotification
	    execute 'autocmd! BufWritePost <buffer> echomsg' string(l:message) '| autocmd! writebackupAutomatorNotification'
	augroup END
    endif
endfunction


"- autocmds --------------------------------------------------------------------

augroup writebackupAutomator
    autocmd!
    autocmd BufWritePre * call <SID>InterceptWrite()
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
