" Test creation of automatic backup in a different backup dir. 

let g:WriteBackup_BackupDir = './backup'
cd $TEMP/WriteBackupTest
edit someplace\ else.txt
%s/song/bird/
write

call ListFiles()
call vimtest#Quit() 
