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

" use LaTeX flavor
let g:tex_flavor = "latex"

set timeoutlen=500
