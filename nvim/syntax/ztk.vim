let b:current_syntax = "ztk"

syntax match ztk_tags /\%1l:.*:/ contains=ztk_tag_outer
syntax match ztk_date /\%3l^\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d$/
syntax match ztk_header /\%5l^.*$/ nextgroup=ztk_body

syntax match ztk_tag_outer /:.*:/ contained transparent contains=ztk_tag,ztk_tag_sep
syntax match ztk_tag /[^:]*/ contained
syntax match ztk_tag_sep /:/ contained

highlight! link ztk_tag Blue
highlight! link ztk_tag_sep NonText
highlight! link ztk_date Green
highlight! link ztk_header Title
