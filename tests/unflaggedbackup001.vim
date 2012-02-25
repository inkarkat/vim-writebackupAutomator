" Test no automatic backup when flag is set to 0. 

cd $TEMP/WriteBackupTest
edit important.txt
let b:writebackup = 0
%s/current/fifth/
write

call ListFiles()
call vimtest#Quit() 
