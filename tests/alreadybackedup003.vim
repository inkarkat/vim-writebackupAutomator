" Test no creation of automatic backup when already backed up.
" Tests that no identical backup is created when the functionality is explicitly
" turned on, but without "redate".
" Tests that no backup is created once the original file has been changed (as
" long as the original file has a file date of today).

let g:WriteBackup_AvoidIdenticalBackups = 1

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupRestoreFromPred!
%s/fourth/fifth/
write
write

call ListFiles()
call vimtest#Quit()
