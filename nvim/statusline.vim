
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
    hi User1 cterm=bold gui=bold ctermfg=069 guifg=#486aff
    hi User3 cterm=bold gui=bold guifg=#aaccff ctermfg=153
    hi User4 cterm=bold gui=bold guifg=#6688ff ctermfg=074
    hi User2 cterm=bold gui=bold guifg=#88aaff ctermfg=110
    hi User5 cterm=bold gui=bold guifg=#486aff ctermfg=069
    hi User7 cterm=bold gui=bold guifg=#aaccff ctermfg=153

    " last window always has status line
    set laststatus=2

    set noshowmode

    " set statusline
    set statusline=
    set statusline +=%{ModeColor()}                                     " get color
    set statusline +=%1*\ %-8(%{toupper(g:currentmode[mode()])}%)       " mode
    set statusline +=%4*\ %l/%L\                                        " line number/lines
    set statusline +=%2*\ %-v\                                          " column
    set statusline +=%3*\ %<%{pathshorten(expand('%:f'))}\              " filename
    set statusline +=%3*%=                                              " space
    set statusline +=%7*%{g:jobrunning}\                                " show if job running
    set statusline +=%7*%m%r%h%w%q%k%3*\                                " flags
    set statusline +=%2*\ %{&ft}\                                       " file type
    set statusline +=%4*\ %{&ff}\                                       " file format
    set statusline +=%5*\ %{&fenc}\                                     " file encoding
endfunction

if !exists("g:jobrunning")
    let g:jobrunning = ""
endif

augroup reload_colors_necessary
    autocmd!
    autocmd VimEnter,ColorScheme    *   call UpdateStatusLineColors()
augroup END

" set color depending on mode
function! ModeColor()
    if (mode() =~# '\v(n|no)')
        exe 'hi User1 ctermfg=069 guifg=#486aff'
    elseif (mode() ==# 'i')
        exe 'hi User1 ctermfg=208 guifg=#ffa000'
    elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't') || mode() == ''
        exe 'hi User1 ctermfg=082 guifg=#33ff33'
    elseif (mode() == 't')
        exe 'hi User1 ctermfg=196 guifg=#ff2000'
    else
        exe 'hi User1 ctermfg=011 guifg=#aaaa44'
    endif

    silent!redraw

    return ""
endfunction
