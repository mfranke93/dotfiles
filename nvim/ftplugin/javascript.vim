" Highlight console.log statements
syntax match ConsoleLog 'console.log(.*);' containedin=ALLBUT,Comment
highlight ConsoleLog ctermfg=14 ctermbg=NONE cterm=NONE guifg=#8FBCBB guibg=NONE gui=NONE
