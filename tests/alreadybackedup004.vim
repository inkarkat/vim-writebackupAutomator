" Test that backup skip message is given only once

let g:WriteBackup_AvoidIdenticalBackups = 1

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupRestoreFromPred!
%s/fourth/fifth/
write
write
echomsg "Second write"
write
echomsg "After second write"

call ListFiles()
call vimtest#Quit()
