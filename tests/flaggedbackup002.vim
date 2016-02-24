" Test no creation of automatic backup when flag is set on unpersisted buffer. 

cd $TEMP/WriteBackupTest
edit new\ file.txt
let b:WriteBackup = 1
call setline(1, 'new text in a new file')
write
echomsg 'Test: No automatic backup attempted'

call ListFiles()
call vimtest#Quit()
