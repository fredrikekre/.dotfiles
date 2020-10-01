" VIM color file
"
" Note: Based on the Monokai theme for Sublime Text

hi clear
set background=dark
if version > 580
	if exists("syntax_on")
		syntax reset
	endif
endif
set t_Co=256
let g:colors_name="Monokai"
hi Character       guifg=#AE81FF guibg=NONE guisp=NONE gui=NONE ctermfg=141 ctermbg=NONE cterm=NONE
hi Comment         guifg=#75715E guibg=NONE guisp=NONE gui=NONE ctermfg=242 ctermbg=NONE cterm=NONE
hi Constant        guifg=#AE81FF guibg=NONE guisp=NONE gui=NONE ctermfg=141 ctermbg=NONE cterm=NONE
hi Cursor          guifg=NONE guibg=#F8F8F0 guisp=NONE gui=NONE ctermfg=NONE ctermbg=255 cterm=NONE
hi CursorLine      guifg=NONE guibg=#3E3D32 guisp=NONE gui=NONE ctermfg=NONE ctermbg=237 cterm=NONE
hi Function        guifg=#A6E22E guibg=NONE guisp=NONE gui=NONE ctermfg=148 ctermbg=NONE cterm=NONE
hi Identifier      guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi Keyword         guifg=#F92672 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi LineNr          guifg=NONE guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi Normal          guifg=#F8F8F2 guibg=#0D0D0B guisp=NONE gui=NONE ctermfg=255 ctermbg=232 cterm=NONE
hi Number          guifg=#AE81FF guibg=NONE guisp=NONE gui=NONE ctermfg=141 ctermbg=NONE cterm=NONE
hi StorageClass    guifg=#F92672 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi String          guifg=#E6DB74 guibg=NONE guisp=NONE gui=NONE ctermfg=186 ctermbg=NONE cterm=NONE
hi Type            guifg=#A6E22E guibg=NONE guisp=NONE gui=underline ctermfg=148 ctermbg=NONE cterm=underline
hi Visual          guifg=NONE guibg=#49483E guisp=NONE gui=NONE ctermfg=NONE ctermbg=238 cterm=NONE

hi link Conditional Keyword
hi link Repeat Keyword

hi link cType Keyword

