" ztk.vim
"
" Plugin for Zettelkasten

function ztk#create_output_dir()
    " create directory ./ztk in home directory if not present
    let l:dir = $HOME . '/ztk'
    let l:dir_not_existing = system('[[ -e ' . l:dir . ' ]] ; echo $?')
    if l:dir_not_existing
        silent! execute ':!mkdir -p ' . l:dir
    endif

    let g:ztk_output_dir = l:dir
endfunction

"------------------------------------------------------------------------------
" Function that creates a new Zettel.
" The Zettel will be in ~/ztk/yyyy-mm-dd_HH-MM-SS.ztk
" The first line will contain tags like :these:are:four:tags:
" The third line will contain date and time.
" The fifth line and following will contain the content.
"
" This function may take up to 20 arguments that each are interpreted as one
" tag.
"
function ztk#zettelkasten(...)
    if !exists('g:ztk_output_dir')
        call ztk#create_output_dir()
    endif

    let l:date = system('echo -n $(date "+%F_%H-%M-%S")')
    let l:new_file_name = g:ztk_output_dir . '/'
                \ . l:date . '.ztk'

    " if tags, create tag line
    let l:tags = ''
    if len(a:000)
        let l:tags = join(a:000, ':')
    endif

    execute('edit ' . l:new_file_name)
    call append(line('0'), ':' . l:tags . ':')
    call append(line('$'), system('echo -n $(date "+%F %H:%M:%S")'))
    call append(line('$'), '')
    call append(line('$'), '')

    if len(a:000)
        " if arguments (=tags), go to end
        execute 'normal G'
    else
        " else, end in insert mode between colons
        execute 'normal gg^l'
    endif

    startinsert
endfunction
