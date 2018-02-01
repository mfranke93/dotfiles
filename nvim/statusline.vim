
function! UpdateStatusLineColors()
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
    hi User1 ctermfg=232 ctermbg=069 guifg=#222222 guibg=#486aff
    hi User3 guibg=#aaccff guifg=#222222 ctermfg=232 ctermbg=153
    hi User4 guibg=#6688ff guifg=#222222 ctermfg=232 ctermbg=074
    hi User2 guibg=#88aaff guifg=#222222 ctermfg=232 ctermbg=110
    hi User5 guibg=#486aff guifg=#222222 ctermfg=232 ctermbg=069
    hi User7 guibg=#aaccff guifg=#dd0000 ctermfg=124 ctermbg=153

    " last window always has status line
    set laststatus=2

    set noshowmode

    " set statusline
    set statusline=
    set statusline +=%{ModeColor()}                                     " get color
    set statusline +=%1*\ %-8(%{toupper(g:currentmode[mode()])}%)       " mode
    set statusline +=%4*\ %l/%L\                                        " line number/lines
    set statusline +=%2*\ %-v\                                          " column
    set statusline +=%3*\ %<%F\                                           " filename
    set statusline +=%3*%=                                              " space
    set statusline +=%7*%m%r%h%w%q%k%3*\                                " flags
    set statusline +=%2*\ %{&ft}\                                       " file type
    set statusline +=%4*\ %{&ff}\                                       " file format
    set statusline +=%5*\ %{&fenc}\                                     " file encoding
endfunction

augroup reload_colors_necessary
    autocmd!
    autocmd VimEnter,ColorScheme    *   call UpdateStatusLineColors()
augroup END

" set color depending on mode
function! ModeColor()
    if (mode() =~# '\v(n|no)')
        exe 'hi User1 ctermfg=232 ctermbg=069 guifg=#222222 guibg=#486aff'
    elseif (mode() ==# 'i')
        exe 'hi User1 ctermfg=232 ctermbg=208 guifg=#222222 guibg=#ffa000'
    elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't') || mode() == ''
        exe 'hi User1 ctermfg=232 ctermbg=082 guifg=#222222 guibg=#33ff33'
    elseif (mode() == 't')
        exe 'hi User1 ctermfg=232 ctermbg=196 guifg=#222222 guibg=#ff2000'
    else
        exe 'hi OtherModeHighlight  ctermfg=232 ctermbg=011 guifg=#222222 guibg=#aaaa44'
    endif

    redraw

    return ""
endfunction
