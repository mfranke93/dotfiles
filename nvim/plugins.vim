"-----------------------------------------------------------------------------
" Install plugins
"-----------------------------------------------------------------------------
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

"-----------------------------------------------------------------------------
" FZF.vim key bindings
"-----------------------------------------------------------------------------
" Use <C-X> to open result in new split, <C-V> for new vsplit
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>a :Ag<cr>

let g:LanguageClient_serverCommands = {
    \ 'javascript': ['tcp://127.0.0.1:2089']
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
