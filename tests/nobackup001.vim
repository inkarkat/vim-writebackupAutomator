" Test no automatic backup when no backup exists. 

cd $TEMP/WriteBackupTest
edit not\ important.txt
%s/junk/more &/
write

call ListFiles()
call vimtest#Quit() 
