" Test creation of automatic backup when older backups exist. 

cd $TEMP/WriteBackupTest
edit important.txt
%s/current/fifth/
write

call ListFiles()
call vimtest#Quit() 
