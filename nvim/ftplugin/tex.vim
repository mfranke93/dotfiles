" create \left( \right), place cursor inbetween
inoremap <buffer> (( \\left(  \\right)Bhi
inoremap <buffer> [[ \\left[  \\right]Bhi
inoremap <buffer> {{ \\left\\{  \\right\\}Bhi
inoremap <buffer> // \\frac{  }{  }F{;la
inoremap <buffer> \|\| \\middle\|

" arrows
inoremap <buffer> -> \\rightarrow 
inoremap <buffer> => \\Rightarrow 
inoremap <buffer> <- \\leftarrow 
inoremap <buffer> <= \\Leftarrow 

set timeoutlen=500

" set only if not set
if !exists("g:syncpdf")
    let g:syncpdf = ""
endif

function! Synctex()
    execute "silent !zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . bufname('%') . " " . g:syncpdf
endfunction
function! UseMaster()
    let g:syncpdf = bufname('%')[:-5] . ".pdf"
endfunction

nnoremap <C-Space> :call Synctex()<cr>
command! MasterTex call UseMaster()
