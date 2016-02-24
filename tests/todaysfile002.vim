" Test no flagged automatic backup when original file is from today. 

cd $TEMP/WriteBackupTest
edit not\ important.txt
%s/just/today's/
    " Touch this.
    let b:WriteBackup = 0
    write
    let b:WriteBackup = 1
write

call ListFiles()
call vimtest#Quit()
