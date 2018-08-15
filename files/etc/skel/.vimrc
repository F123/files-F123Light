        set term=linux       " Make arrow and other keys work
	scriptencoding utf-8
	set history=1000  				" Store a ton of history (default is 20)
	set spell 		 	        	" spell checking on
	" Setting up the directories {
		set backup 						" backups are nice ...
		set undoreload=10000 "maximum number lines to save for undo on a buffer reload
		set backupdir=$HOME/.vim/backup//  " but not when they clog .
		set directory=$HOME/.vim/swap// 	" Same for swap files
		set viewdir=$HOME/.vim/views// 	" same for view files
	set ignorecase					" case insensitive search
	set smartcase					" case sensitive when uc present
	set gdefault					" the /g flag on :s substitutions by default
	set wrap                     	" wrap long lines
    set noruler
	set formatoptions+=l
	set lbr
	set shiftwidth=4               	" use indents of 4 spaces
	"set expandtab 	  	     		" tabs are spaces, not tabs
	set tabstop=4 					" an indentation every four columns
	set softtabstop=4 				" let backspace delete indent
	let mapleader = ','
    nnoremap ; :

	" Yank from the cursor to the end of the line, to be consistent with C and D.
	nnoremap Y y$
		
	" Shortcuts
	" Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
	cmap cd. lcd %:p:h

	" For when you forget to sudo.. Really Write the file.
	cmap w!! w !sudo tee % >/dev/null
" }
" File conversion/opening
" rtf
autocmd BufReadPre *.rtf silent set ro
autocmd BufReadPost *.rtf silent %!unrtf --text
