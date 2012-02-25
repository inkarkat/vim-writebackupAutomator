" Test creation of automatic backup when flag is set. 

cd $TEMP/WriteBackupTest
edit not\ important.txt
let b:writebackup = 1
%s/junk/more &/
write

call ListFiles()
call vimtest#Quit() 
