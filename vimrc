" vimrc from http://derekwyatt.org/2009/08/20/the-absolute-bare-minimum/
" Forget being compatible with good ol' vi
set nocompatible

" Get that filetype stuff happening
filetype on
filetype plugin on
filetype indent on

" Turn on that syntax highlighting
syntax on

" Why is this not a default
set hidden

" Don't update the display while executing macros
set lazyredraw

" At least let yourself know what mode you're in
set showmode

" Enable enhanced command-line completion. Presumes you have compiled
" with +wildmenu. See :help 'wildmenu'
set wildmenu

" Let's make it easy to edit this file (mnemonic for the key sequence is
" 'e'dit 'v'imrc)
nmap <silent> ,ev :e $MYVIMRC<cr>

" And to source this file as well (mnemonic for the key sequence is
" 's'ource 'v'imrc)
nmap <silent> ,sv :so $MYVIMRC<cr>

" Tab stops are 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" Let's try ignorecase smartcase for searches.
set ignorecase
set smartcase

" Allow backspacing over indent, EOL, and the start of an insert
set backspace=2

" Make the 'cw' and like commands put a $ at the end instead of just deleting
" the text and replacing it
set cpoptions=ces$

" set the GUI options the way I like
set guioptions=acg

" This is the timeout used while waiting for user input on a multi-keyed macro
" or while just sitting and waiting for another key to be pressed measured
" in milliseconds.
"
" i.e. for the ",d" command, there is a "timeoutlen" wait period between the
"      "," key and the "d" key.  If the "d" key isn't pressed before the
"      timeout expires, one of two things happens: The "," command is executed
"      if there is one (which there isn't) or the command aborts.
set timeoutlen=500

" Keep some stuff in the history
set history=100

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8

" Disable encryption (:X)
set key=

" Make the command-line completion better
set wildmenu
set wildmode=list,full

" Same as default except that I remove the 'u' option
set complete=.,w,b,t

" When completing by tag, show the whole tag, not just the function name
set showfulltag

" get rid of the silly characters in separators
set fillchars = ""

" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Enable search highlighting
set hlsearch

" Incrementally match the search
set incsearch

" line numbering
set relativenumber
set number

" Create backup, swap and undo directory if it does not exist
if !isdirectory($HOME . "/.vim/swp")
  call mkdir($HOME . "/.vim/swp", "p")
endif
if !isdirectory($HOME . "/.vim/undo")
  call mkdir($HOME . "/.vim/undo", "p")
endif

" Set backup, swap and undo directories.
set directory=~/.vim/swp//,/tmp

set undofile
set undodir=~/.vim/undo//,/tmp
set undolevels=1000
set undoreload=10000

" System default for mappings is now the "," character
let mapleader = ","
let maplocalleader = "\\"

" Turn off that stupid highlight search
nmap <silent> <LEADER>n :nohls<CR>

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

"Make indent work in normal and visual mode and unindent in insert mode possible.
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

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
" Set up the window colors and size
"-----------------------------------------------------------------------------

if $TERM == "xterm-256color"
  set t_Co=256
elseif $TERM == "screen-256color"
  set t_Co=256
endif

colorscheme monokai
if has("gui_running")
    set guifont=Source\ Code\ Pro\ 10
endif
:nohls

"-----------------------------------------------------------------------------
" Install plugins
"-----------------------------------------------------------------------------
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

" Own stuff
"-----------------------------------------------------------------------------
" save and make by ,m
"-----------------------------------------------------------------------------
nmap <leader>m :w<CR>:make<CR>

" highlight current line
set cursorline

syntax enable

set clipboard=unnamedplus

"status line
set statusline=%F%m%r%h%w\ [%l/%L,\ %v]\ [%p%%]\ %=[TYPE=%Y]\ [FMT=%{&ff}]\ %{\"[ENC=\".(&fenc==\"\"?&enc:&fenc).\"]\"}
set laststatus=2
set showcmd

" set cursor shapes in uxterm
let &t_SI = "\<Esc>[6 q"
"let &t_SR = "\<Esc>[4 q" " this one is not recognized, but we don't need it for replace that badly
let &t_EI = "\<Esc>[2 q"

" No spaces for tabs in Makefiles
autocmd FileType make setlocal noexpandtab

" Use file name ending .gv for graphviz files
augroup GraphvizFiletype
  au! BufRead,BufNewFile,BufEnter *.gv set filetype=dot
augroup END

" disable ins key in insert mode
inoremap [2~ <NOP>

" disable the MENU key in insert mode. It does weird stuff
inoremap [29~ <NOP>

" save folds on exit, load on enter, do not make dependent on cwd
function! MakeViewIfNotCommitmsg()
    if &ft =~ 'GITCOMMIT'
        return
    endif
    mkview
endfunction

function! LoadViewIfNotCommitmsg()
    if &ft =~ 'GITCOMMIT'
        return
    endif
    silent loadview
endfunction

au BufWinLeave ?* call MakeViewIfNotCommitmsg()
au BufWinEnter ?* call LoadViewIfNotCommitmsg()
set viewoptions-=options

"-----------------------------------------------------------------------------
" FZF.vim key bindings
"-----------------------------------------------------------------------------
" Use <C-X> to open result in new split, <C-V> for new vsplit
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>a :Ag<cr>

set mouse=a

"-----------------------------------------------------------------------------
" Status line colors
"-----------------------------------------------------------------------------
" first, enable status line always
set laststatus=2

" now set it up to change the status line based on mode
if version >= 700
    au InsertEnter * hi StatusLine term=reverse ctermfg=46 ctermbg=0 gui=bold guifg=Black guibg=LimeGreen
    au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=14 gui=bold guifg=White guibg=Black
    au BufWinEnter * hi StatusLine term=reverse ctermfg=0 ctermbg=14 gui=bold guifg=White guibg=Black
endif

filetype plugin indent on

