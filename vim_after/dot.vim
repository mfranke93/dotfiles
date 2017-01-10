augroup GraphvizFiletype
  au! BufRead,BufNewFile,BufEnter *.gv set filetype=dot
augroup END

" tools for working with graphviz
augroup graphviz
    " from andrewvos.com
    " This callback will be executed when the entire command is completed
    function! BackgroundCommandClose(channel)
      "" Read the output from the command into the quickfix window
      "execute "cfile! " . g:backgroundCommandOutput
      "" Open the quickfix window
      "copen
      unlet g:backgroundCommandOutput
    endfunction

    function! RunBackgroundCommand(command)
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
        " Notice that we're only capturing out, and not err here. This is because, for some reason, the callback
        " will not actually get hit if we write err out to the same file. Not sure if I'm doing this wrong or?
        let g:backgroundCommandOutput = tempname()
        call job_start(a:command, {'close_cb': 'BackgroundCommandClose', 'out_io': 'file', 'out_name': g:backgroundCommandOutput})
      endif
    endfunction

    function! GraphvizCreateTempfile()
        if exists('g:graphviz_temp_file')
            " echo "Temp file already exists: ".g:graphviz_temp_file
            return
        else
            let g:graphviz_temp_file = system("mktemp")
        endif
    endfunction

    function! GraphvizCompileBuffer()
        call GraphvizCreateTempfile()
        echo expand('%:p')
        let l:command = "dot -Tpng ".expand('%:p')." > ".g:graphviz_temp_file
        echo l:command
        call system(l:command)
    endfunction

    function! GraphvizShowCompiledFile()
        silent call RunBackgroundCommand("feh" . g:graphviz_temp_file)
    endfunction

    autocmd FileType dot nnoremap <localleader>c :call GraphvizCompileBuffer()<cr> 
    autocmd FileType dot nnoremap <localleader>v :call GraphvizShowCompiledFile()<cr>

augroup END

