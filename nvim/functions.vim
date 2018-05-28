" No spaces for tabs in Makefiles
autocmd FileType make setlocal noexpandtab

" Use file name ending .gv for graphviz files
augroup GraphvizFiletype
  au! BufRead,BufNewFile,BufEnter *.gv set filetype=dot
augroup END

" Force use tex
augroup TexFileOpen
    au! BufRead,BufNewFile *.tex set filetype=tex
augroup END

"-----------------------------------------------------------------------------
" Function to make current instance remote-send:able server for neovim-remote
"-----------------------------------------------------------------------------
function! MakeServer()
    if exists("v:servername")
        call system("ln -sf " . v:servername . " /tmp/nvimsocket")
        let g:current_instance_is_server = 1
        echo "Current nvim instance now used /tmp/nvimsocket"
    else
        echoerr "Variable v:servername was not set, could not start listening on /tmp/nvimsocket"
    endif
endfunction

function! ClearServer()
    if exists("g:current_instance_is_server")
        call system("rm /tmp/nvimsocket")
        unlet g:current_instance_is_server
    endif
endfunction

augroup IfIsServerClearInvalidSymlinkOnLeave
    autocmd!
    autocmd VimLeave * call ClearServer()
augroup END

command! Server :call MakeServer()

" DiffOrig
command! -nargs=0 DiffOrig rightbelow vertical new | 
            \ set buftype=nofile | 
            \ set bufhidden=wipe | 
            \ set noswapfile | 
            \ r # | 
            \ 0d_ | 
            \ let &filetype=getbufvar('#', '&filetype') | 
            \ execute 'autocmd BufWipeout <buffer> diffoff!' | 
            \ diffthis | 
            \ wincmd p | 
            \ diffthis



" Doxygen syntax highlight in CPP comments
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.hpp,*.cpp      set filetype=cpp.doxygen
augroup END

" set background to match terminal after vi is loaded
augroup bgterm
    autocmd!
    autocmd VimEnter,ColorScheme * hi Normal ctermbg=none
augroup END

" show cursorline only in normal mode
augroup cursorline
    autocmd!
    autocmd InsertEnter *                       set nocursorline
    autocmd InsertLeave *                       set cursorline
    autocmd Colorscheme *                       set cursorline
augroup END

" split help window to right
function! ILikeHelpToTheRight()
    " only if window wide enough
    if winwidth('%') > 160
        "if !exists('w:help_is_moved') || w:help_is_moved != "right"
            wincmd L
            let w:help_is_moved = "right"
        "endif
    endif
endfunction

augroup HelpPages
    autocmd FileType help nested call ILikeHelpToTheRight()
augroup END
