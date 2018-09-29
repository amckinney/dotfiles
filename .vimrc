call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go'
Plug 'fholgado/minibufexpl.vim'
Plug 'flazz/vim-colorschemes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
Plug 'uber/prototool', { 'rtp':'vim/prototool', 'branch':'dev' }
call plug#end()

set nocompatible

" ------ General Configuration ------ "
let mapleader = ","
set ai                       " Keep indentation from previous line
set background=dark          " Background color
set hlsearch                 " Highlight search results
set nu                       " Display line numbers
set sb                       " Split below
set spr                      " Split right
set sw=4                     " Number of spaces to use for indent
set ts=4                     " Number of spaces tab will count for
set mouse=a                  " Mouse support
set clipboard+=unnamedplus   " Neovim copy support
set list lcs=tab:»\ ,trail:· " Display whitespace

" ------ Custom Mapping ------ "
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-]> :bn<CR>
nnoremap <C-[> :bp<CR>
vmap <TAB> >gv
vmap <S-TAB> <gv

" ------ ale --------- "
let g:ale_linters = {
\   'go': ['go vet', 'golint', 'go build'],
\}
let g:ale_lint_on_text_changed = 'never'

" ------ vim-go ------ "
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1

let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

let g:go_highlight_space_tab_error = 0
let g:go_highlight_trailing_whitespace_error = 0

" ------ deoplete ------ "
set completeopt=menu,preview,longest
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH . '/bin/gocode'

" ------- minibuf ------ "
let g:miniBufExplSplitToEdge = 0
let g:miniBufExplBRSplit = 0

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
