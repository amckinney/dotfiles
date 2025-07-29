call plug#begin('~/.vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'

call plug#end()

set nocompatible

" ------ General Configuration ------ "
let mapleader = ","
set ai                         " Keep indentation from previous line
set background=dark            " Background color
set hlsearch                   " Highlight search results
set incsearch                  " Highlight while searching
set expandtab                  " Don't use actual tab characers
set nu                         " Display line numbers
set sb                         " Split below
set spr                        " Split right
set sw=2                       " Number of spaces to use for indent
set ts=2                       " Number of spaces tab will count for
set re=2                       " Required for TypeScript editing.
set mouse=a                    " Mouse support
set list lcs=tab:»\ ,trail:·   " Display whitespace
set clipboard=unnamed          " Copy to the system clipboard by default
set backspace=indent,eol,start " Configure backspace
set updatetime=100             " Time to update the status line (ms)

" ------ Custom Mapping ------ "
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
vmap <TAB> >gv
vmap <S-TAB> <gv
imap jj <Esc>
imap kk <C-x><C-o>

" Yank and paste operations preceded by <leader> should use system clipboard.
nnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
vnoremap <leader>y "+y

nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" ------ nerdtree ------ "
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
nnoremap <C-n> :call g:NERDTreeCustomToggle()<CR>

au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeWinSize = 30
let NERDTreeShowHidden = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeChDirMode = 0
let NERDTreeIgnore = ['\.git$[[dir]]', '\.pyc$']

function! g:NERDTreeCustomToggle()
	let g:curnerdtreetogglewnum = winnr()
	if g:NERDTree.IsOpen()
		exec "NERDTreeClose"
		if &modifiable && @% != "" && !isdirectory(@%)
		  exec g:curnerdtreetogglewnum . "wincmd ="
		endif
	elseif &modifiable && @% != "" && !isdirectory(@%)
		exec "NERDTreeFind"
		exec "set winfixwidth"
		exec g:curnerdtreetogglewnum . "wincmd ="
	else
		exec "NERDTreeCWD"
		exec "set winfixwidth"
		exec g:curnerdtreetogglewnum . "wincmd ="
	endif
endfunction

" ------ Custom Color Mapping (papercolor)  ------ "
colorscheme hybrid
set hlsearch
hi Search ctermbg=LightYellow
hi htmlBold gui=bold guifg=#af0000 ctermfg=124
hi htmlItalic gui=italic guifg=#ff8700 ctermfg=214
