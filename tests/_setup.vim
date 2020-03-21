call vimtest#AddDependency('vim-ingo-library')
call vimtest#AddDependency('vim-writebackup')
call vimtest#AddDependency('vim-writebackupVersionControl')

runtime plugin/writebackup.vim
runtime plugin/writebackupVersionControl.vim
runtime plugin/writebackupAutomator.vim

set noruler " Otherwise, the captured output may be truncated; we have long filenames.

" The tests rely on $TEMP.
if ! exists('$TEMP')
    let $TEMP = '/tmp'
endif

" Add the test directory to $PATH so that the 'setup' and 'listfiles' helper
" scripts can be executed easily.
let $PATH .= ingo#os#PathSeparator() .  expand('<sfile>:p:h')

" Set up the modifiable test data in the temporary location.
if ! vimtest#System('setup', 1)
    call vimtest#BailOut('External setup script failed with exit status ' . v:shell_error)
endif

" This evaluation function allows to compare the modified test data with the
" expected result. It is called at the end of each test.
function! ListFiles()
    new
    0r !listfiles
    call vimtest#SaveOut()
endfunction
