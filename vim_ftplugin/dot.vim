" from andrewvos.com
" This callback will be executed when the entire command is completed
function! BackgroundCommandClose(channel)
    "" Read the output from the command into the quickfix window
    "execute "cfile! " . g:backgroundCommandOutput
    "" Open the quickfix window
    "copen
    unlet g:backgroundCommandOutput
endfunction

function! GraphvizCreateTempfile()
    " Create a new temporary file to write png to
    if exists('g:graphvizOutputFile')
        return
    else
        " Using tempname instead of mktemp means vim will automatically clean
        " up after the session ends.
        let g:graphvizOutputFile = tempname()  
        " system("mktemp | tr -d '\n'")
    endif
endfunction

function! GraphvizCompileBuffer()
    " Compile the current buffer into a PNG file using GraphViz dot command.
    
    " Make sure we're running VIM version 8 or higher.
    if v:version < 800
        echoerr 'RunBackgroundCommand requires VIM version 8 or higher'
        return
    endif

    if exists('g:backgroundCommandOutput')
        echo 'Already running task in background'
    else
        echo 'Running task in background'
        " Launch the job.
        let g:backgroundCommandOutput = tempname()
        let currentFile = expand("%:p")
        call GraphvizCreateTempfile()
        call job_start(["dot", "-Tpng", currentFile], {'close_cb': 'BackgroundCommandClose', 'out_io': 'file', 'out_name': g:graphvizOutputFile})
        unlet currentFile
    endif
endfunction

function! GraphvizShowCompiledFile()
    silent call job_start(["feh", g:graphvizOutputFile], {'out_io': 'file', 'out_name': '/dev/null'})
endfunction

function! GraphvizSaveCompiledFile()
    " Save PNG to file.
    call inputsave()
    let outfile = input("Choose a file to save PNG to: ")
    call inputrestore()
    call system("mv " . g:graphvizOutputFile . " " . outfile)
    echo "File saved as " . outfile
    unlet outfile
endfunction

nnoremap <localleader>c :call GraphvizCompileBuffer()<cr> 
nnoremap <localleader>v :call GraphvizShowCompiledFile()<cr>
nnoremap <localleader>s :call GraphvizSaveCompiledFile()<cr>

