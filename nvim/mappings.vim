" Let's make it easy to edit this file (mnemonic for the key sequence is
" 'e'dit 'v'imrc)
nmap <silent> ,ev :e $MYVIMRC<cr>

" And to source this file as well (mnemonic for the key sequence is
" 's'ource 'v'imrc)
nmap <silent> ,sv :so $MYVIMRC<cr>


" Turn off that stupid highlight search
nmap <silent> <LEADER>n :nohls<CR>

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

"-----------------------------------------------------------------------------
" save and make by ,m
"-----------------------------------------------------------------------------
nmap <leader>m :w<CR>:make<CR>

" disable ins key in insert mode
inoremap [2~ <NOP>

" disable the MENU key in insert mode. It does weird stuff
inoremap [29~ <NOP>

" <C-Space> for omnifunc
inoremap <C-Space> <C-X><C-O>

" <Up/Down> for selecting in completion (Pmenu)
inoremap <Up> <C-P>
inoremap <Down> <C-N>
