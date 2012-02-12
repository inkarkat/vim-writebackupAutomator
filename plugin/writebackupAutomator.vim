" writebackupAutomator.vim: writebackup plugin automatically writes a backup on
" the first write. 
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 
"   - writebackup plugin (vimscript #1828). 
"   - writebackupVersionControl plugin (vimscript #1829), version 2.30 or higher. 

" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.00.002	13-Feb-2012	Implement missing bits and pieces, driven by the
"				test suite. 
"				Make backup success and error messages visible
"				to the user through a fire-once autocmd on
"				BufWritePost. 
"	001	10-Feb-2012	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_writebackupAutomator') || (v:version < 700)
    finish
endif
let g:loaded_writebackupAutomator = 1

"- functions ------------------------------------------------------------------

function! s:today()
    return strftime('%Y%m%d')
endfunction
function! writebackupAutomator#Message( text, ... )
    if a:0
	execute 'echohl' a:1
    endif
    echomsg a:text
    if a:0
	echohl None
    endif
endfunction
function! s:DelayedMessage( text, ... )
    " To ensure that the message is visible to the user, print it via a
    " fire-once autocmd _after_ the original buffer is written. 
    augroup writebackupAutomatorNotification
	execute printf('autocmd! BufWritePost <buffer> call writebackupAutomator#Message(%s)|autocmd! writebackupAutomatorNotification',
	\   string(a:text) .
	\   (a:0 ? ', ' . string(a:1) : '')
	\)
    augroup END
endfunction
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

	" When the buffer is flagged, but not yet persisted, do not attempt a
	" backup. 
	if ! filereadable(l:filespec)
	    return
	endif
    else
	" If the buffer has been negatively flagged, do not perform a backup. 
	if exists('b:writebackup') && ! b:writebackup
	    return
	endif

	" When there's already a backup from today, do not perform a backup. 
	let l:lastBackupDate = writebackupVersionControl#GetVersion(l:backupFiles[-1])[0:-2]
	let l:today = s:today()

	if l:lastBackupDate ==# l:today
	    " Today, a backup was already made. 
	    return
	elseif l:lastBackupDate ># l:today
	    let v:warningmsg = 'The last backup was done in the future?!'
	    call s:DelayedMessage(v:warningmsg, 'WarningMsg')
	    return
	endif
    endif

    call s:MakeBackup(l:filespec)
endfunction
function! s:MakeBackup( filespec )
    " Whatever WriteBackupVersionControl prints as status message, is soon
    " overwritten by the status message of the impending :write command. And,
    " the "This file is already backed up" error is only informational here.
    " Therefore, suppress the message until all writes are done. 
    silent let l:backupStatus = writebackupVersionControl#WriteBackupOfSavedOriginal(a:filespec, 0)
    if l:backupStatus == 0
	" File is already backed up; turn the error into an informational
	" message. 
	call s:DelayedMessage(v:errmsg)
    elseif l:backupStatus == 1
	" The writing of the backup file was successful. 
	" As it's cumbersome to get the backup filespec from
	" WriteBackupVersionControl, we re-create it here ourselves. 
	let l:message = printf('Automatically backed up as "%s.%sa"',
	\	writebackup#AdjustFilespecForBackupDir(a:filespec, 1),
	\	s:today()
	\)
	call s:DelayedMessage(l:message)
    elseif l:backupStatus == -1
	" An error occurred; reuse the error message from
	" WriteBackupVersionControl. 
	call s:DelayedMessage(v:errmsg, 'ErrorMsg')
    endif
endfunction


"- autocmds --------------------------------------------------------------------

augroup writebackupAutomator
    autocmd!
    autocmd BufWritePre * call <SID>InterceptWrite()
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
