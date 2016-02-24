" Test no creation of automatic backup when already backed up. 
" Tests that an identical old backup file is re-dated when the original file is unmodified. 

call vimtest#ErrorAndQuitIf(g:WriteBackup_AvoidIdenticalBackups !=# 'redate', 'Default behavior on identical backups is redate')

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupRestoreFromPred!
write

call ListFiles()
call vimtest#Quit() 
