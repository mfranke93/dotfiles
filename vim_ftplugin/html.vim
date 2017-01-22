function! HtmlEncodeUmlauts()
    silent! execute "%s/ä/\\&auml;/g"
    silent! execute "%s/Ä/\\&Auml;/g"
    silent! execute "%s/ö/\\&ouml;/g"
    silent! execute "%s/Ö/\\&Ouml;/g"
    silent! execute "%s/ü/\\&uuml;/g"
    silent! execute "%s/Ü/\\&Uuml;/g"
    silent! execute "%s/ß/\\&szlig;/g"
endfunction

function! HtmlDecodeUmlauts()
    silent! execute "%s/\&auml;/ä/g"
    silent! execute "%s/\&Auml;/Ä/g"
    silent! execute "%s/\&ouml;/ö/g"
    silent! execute "%s/\&Ouml;/Ö/g"
    silent! execute "%s/\&uuml;/ü/g"
    silent! execute "%s/\&Uuml;/Ü/g"
    silent! execute "%s/\&szlig;/ß/g"
endfunction

nnoremap <localleader>e :call HtmlEncodeUmlauts()<cr>
nnoremap <localleader>d :call HtmlDecodeUmlauts()<cr>
