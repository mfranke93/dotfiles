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

" Enable enhanced command-line completion. Presumes you have compiled
" with +wildmenu. See :help 'wildmenu'
set wildmenu

" Let's try ignorecase smartcase for searches.
set ignorecase
set smartcase

" Allow backspacing over indent, EOL, and the start of an insert
set backspace=2

" Make the 'cw' and like commands put a $ at the end instead of just deleting
" the text and replacing it
set cpoptions=$

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
set timeoutlen=200

" do not wait after <ESC>
set ttimeoutlen=0

" Keep some stuff in the history
set history=100

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8

" Make the command-line completion better
set wildmenu
set wildmode=list,full

" Same as default except that I remove the 'u' option
set complete=.,w,b,t

" When completing by tag, show the whole tag, not just the function name
set showfulltag

" get rid of the silly characters in separators
set fillchars = ""

" show trailing spaces
set list
set listchars=tab:»\ ,trail:•
 
" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Enable search highlighting
set hlsearch

" Incrementally match the search
set incsearch

" line numbering
set relativenumber
set number

" Tab stops are 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" Create backup, swap and undo directory if it does not exist
if !isdirectory($HOME . "/.nvim/swp")
  call mkdir($HOME . "/.nvim/swp", "p")
endif
if !isdirectory($HOME . "/.nvim/undo")
  call mkdir($HOME . "/.nvim/undo", "p")
endif

" Set backup, swap and undo directories.
set directory=~/.nvim/swp//,/tmp

set undofile
set undodir=~/.nvim/undo//,/tmp
set undolevels=1000
set undoreload=10000

" mode lines
set modeline
set modelines=5

set grepprg=rg\ --vimgrep

" System default for mappings is now the "," character
let mapleader = ","
let maplocalleader = "\\"

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=256

colorscheme codefocus
set bg=dark
nohls

" highlight current line
set cursorline

syntax enable

set clipboard=unnamedplus
set viewoptions-=options
if exists('&inccommand')
    set inccommand=nosplit
endif
set mouse=a

filetype plugin indent on
