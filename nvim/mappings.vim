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

" Disable arrow keys to get rid of the habit of using them.
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
noremap <S-Up> <NOP>
noremap <S-Down> <NOP>
noremap <S-Left> <NOP>
noremap <S-Right> <NOP>
inoremap <S-Up> <NOP>
inoremap <S-Down> <NOP>
inoremap <S-Left> <NOP>
inoremap <S-Right> <NOP>
noremap <C-Up> <NOP>
noremap <C-Down> <NOP>
noremap <C-Left> <NOP>
noremap <C-Right> <NOP>
inoremap <C-Up> <NOP>
inoremap <C-Down> <NOP>
inoremap <C-Left> <NOP>
inoremap <C-Right> <NOP>
noremap <S-C-Up> <NOP>
noremap <S-C-Down> <NOP>
noremap <S-C-Left> <NOP>
noremap <S-C-Right> <NOP>
inoremap <S-C-Up> <NOP>
inoremap <S-C-Down> <NOP>
inoremap <S-C-Left> <NOP>
inoremap <S-C-Right> <NOP>

" Move between windows (does not work in tmux)
nnoremap <Up> :wincmd k<cr>
nnoremap <Down> :wincmd j<cr>
nnoremap <Right> :wincmd l<cr>
nnoremap <Left> :wincmd h<cr>

"-----------------------------------------------------------------------------
" save and make by ,m
"-----------------------------------------------------------------------------
nmap <leader>m :w<CR>:make<CR>

" disable ins key in insert mode
inoremap [2~ <NOP>

" disable the MENU key in insert mode. It does weird stuff
inoremap [29~ <NOP>
