" Test no creation of automatic backup when backup from today exists. 

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup
%s/current/fifth/
write

call ListFiles()
call vimtest#Quit() 
