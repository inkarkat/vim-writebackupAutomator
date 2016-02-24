" Test creation of automatic backup when already backed up. 
" Tests that identical backups are created when the functionality is explicitly
" turned off. 

let g:WriteBackup_AvoidIdenticalBackups = 0

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupRestoreFromPred!
write

call ListFiles()
call vimtest#Quit() 
