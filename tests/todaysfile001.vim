" Test no creation of automatic backup when original file is from today. 

call vimtest#ErrorAndQuitIf(g:WriteBackup_AvoidIdenticalBackups !=# 'redate', 'Default behavior on identical backups is redate')

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupRestoreFromPred!
write

call ListFiles()
call vimtest#Quit() 
