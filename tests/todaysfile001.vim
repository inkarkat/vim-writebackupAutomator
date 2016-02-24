" Test no redate of automatic backup when original file is from today. 

call vimtest#ErrorAndQuitIf(g:WriteBackup_AvoidIdenticalBackups !=# 'redate', 'Default behavior on identical backups is redate')

cd $TEMP/WriteBackupTest
edit important.txt
    " Touch this.
    let b:WriteBackup = 0
    write
    unlet b:WriteBackup
write

call ListFiles()
call vimtest#Quit()
