" Test failing automatic backup due to artificial failure. 
" Tests that no backup file is created and an error message is printed. 

function! MyBackupDir(originalFilespec, isQueryOnly)
    if a:isQueryOnly
	return '.'
    else
	throw 'artificial backup dir failure'
    endif
endfunction

unlet g:WriteBackup_BackupDir
let g:WriteBackup_BackupDir = function('MyBackupDir')
cd $TEMP/WriteBackupTest
edit important.txt
%s/current/fifth/
write

call ListFiles()
call vimtest#Quit() 
