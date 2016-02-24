" Test skipping automatic backup when the original file has not been written.
" Tests that no backup file is created.

cd $TEMP/WriteBackupTest
call setline(1, "Just some old backup lying around")
write newfile.txt.19990101a

edit newfile.txt
call setline(1, "An unrelated new file")
write

call ListFiles()
call vimtest#Quit()
