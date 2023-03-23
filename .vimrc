call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go'
Plug 'fholgado/minibufexpl.vim'
Plug 'flazz/vim-colorschemes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'

" Deoplete requires special installation for non-neovim setups.
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

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

" ----- language ----- "
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" ------ ale --------- "
let g:ale_linters = {
\   'go': ['go vet', 'golint', 'go build'],
\   'proto': ['buf-lint'],
\   'python': ['pyright'],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1

let g:ale_fixers = {
\   'proto': ['buf-format'],
\   'typescript': ['deno'],
\}
let g:ale_fix_on_save = 1

" -------- LSP ------- "
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_signs_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0

if executable('bufls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'bufls',
        \ 'cmd': {server_info->['bufls']},
        \ 'allowlist': ['proto'],
        \ })
endif

if executable("deno")
  augroup LspTypeScript
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
    \ "name": "deno lsp",
    \ "cmd": {server_info -> ["deno", "lsp"]},
    \ "root_uri": {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), "tsconfig.json"))},
    \ "allowlist": ["typescript", "typescript.tsx"],
    \ "initialization_options": {
    \     "enable": v:true,
    \     "lint": v:true,
    \     "unstable": v:true,
    \   },
    \ })
  augroup END
endif

if executable('pylsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

if executable('rust-analyzer')
  au User lsp_setup call lsp#register_server({
        \   'name': 'rust-analyzer',
        \   'cmd': {server_info->['rust-analyzer']},
        \   'whitelist': ['rust'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" ------ vim-go ------ "
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

let g:go_auto_type_info = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_trailing_whitespace_error = 0

" -------- rust -------- "
let g:rustfmt_autosave = 1

" ------ deoplete ------ "
set completeopt=menu,preview,longest
let g:deoplete#enable_at_startup = 0
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
set hlsearch
hi Search ctermbg=LightYellow
hi htmlBold gui=bold guifg=#af0000 ctermfg=124
hi htmlItalic gui=italic guifg=#ff8700 ctermfg=214
