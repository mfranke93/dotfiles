"-----------------------------------------------------------------------------
" Install plugins
"-----------------------------------------------------------------------------
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'airblade/vim-gitgutter'
call plug#end()

"-----------------------------------------------------------------------------
" FZF.vim key bindings
"-----------------------------------------------------------------------------
" Use <C-X> to open result in new split, <C-V> for new vsplit
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>a :Ag<cr>
