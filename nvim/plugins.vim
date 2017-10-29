"-----------------------------------------------------------------------------
" Install plugins
"-----------------------------------------------------------------------------
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

"-----------------------------------------------------------------------------
" FZF.vim key bindings
"-----------------------------------------------------------------------------
" Use <C-X> to open result in new split, <C-V> for new vsplit
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>a :Ag<cr>

" advanced cpp highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1