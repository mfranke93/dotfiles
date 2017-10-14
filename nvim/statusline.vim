" mapping from mode() output to name
let g:currentmode={
    \ 'n'  : 'NORMAL ',
    \ 'no' : 'N·Operator Pending ',
    \ 'v'  : 'VISUAL ',
    \ 'V'  : 'V·Line ',
    \ '^V' : 'V·Block ',
    \ '' : 'V·Block ',
    \ 's'  : 'Select ',
    \ 'S'  : 'S·Line ',
    \ '^S' : 'S·Block ',
    \ '' : 'S·Block ',
    \ 'i'  : 'INSERT ',
    \ 'R'  : 'REPLACE ',
    \ 'Rv' : 'V·Replace ',
    \ 'c'  : 'Command ',
    \ 'cv' : 'Vim Ex ',
    \ 'ce' : 'Ex ',
    \ 'r'  : 'Prompt ',
    \ 'rm' : 'More ',
    \ 'r?' : 'Confirm ',
    \ '!'  : 'Shell ',
    \ 't'  : 'Terminal '
    \}

" bar colors
hi User3 guibg=#aaccff guifg=#222222 ctermfg=232 ctermbg=153
hi User4 guibg=#6688ff guifg=#222222 ctermfg=232 ctermbg=074
hi User2 guibg=#88aaff guifg=#222222 ctermfg=232 ctermbg=110
hi User5 guibg=#486aff guifg=#222222 ctermfg=232 ctermbg=069
hi User7 guibg=#aaccff guifg=#dd0000 ctermfg=124 ctermbg=153

" colors for modes
hi NormalModeHighlight ctermfg=232 ctermbg=082 guifg=#222222 guibg=#33ff33
hi InsertModeHighlight ctermfg=232 ctermbg=208 guifg=#222222 guibg=#ffa000
hi VisualModeHighlight ctermfg=232 ctermbg=038 guifg=#222222 guibg=#4444fd
hi OtherModeHighlight  ctermfg=232 ctermbg=247 guifg=#222222 guibg=#bbbbbb

" link to User1
hi! link User1 NONE
hi! link User1 NormalModeHighlight

" last window always has status line
set laststatus=2

set noshowcmd
set noshowmode

" set statusline
set statusline=
set statusline +=%{ModeColor()}                                     " get color
set statusline +=%1*\ %-8(%{toupper(g:currentmode[mode()])}%)       " mode
set statusline +=%2*\ %l/%L\                                        " line number/lines
set statusline +=%2*:\ %-v\                                         " column
set statusline +=%3*\ %-20.40F\                                     " filename
set statusline +=%3*%=                                              " space
set statusline +=%7*%m%r%h%w%q%k%3*\                                " flags
set statusline +=%2*\ %{&ft}\                                       " file type
set statusline +=%4*\ %{&ff}\                                       " file format
set statusline +=%5*\ %{&fenc}\                                     " file encoding

" set color depending on mode
function! ModeColor()
    exe 'hi! link User1 NONE'
    if (mode() =~# '\v(n|no)')
        exe 'hi! link User1 NormalModeHighlight'
  elseif (mode() ==# 'i')
        exe 'hi! link User1 InsertModeHighlight'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't') || mode() == ''
        exe 'hi! link User1 VisualModeHighlight'
    else
        exe 'hi! link User1 OtherModeHighlight'
    endif

    redraw

    return ""
endfunction
