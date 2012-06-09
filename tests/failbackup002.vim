" Test failing automatic backup due to removal of original file. 
" Tests that no backup file is created and an error message is printed. 

cd $TEMP/WriteBackupTest
edit important.txt
call vimtest#ErrorAndQuitIf(delete('important.txt'), 'failed to delete original file')
%s/current/fifth/
write

call ListFiles()
call vimtest#Quit() 
