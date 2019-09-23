" Generic Options {{{
set autoindent			" Enable auto indentation
set colorcolumn=80		" Enable ruler at 80 chars
set cursorline			" Highlight current line
set diffopt+=vertical	" Enforce vertical splits for diff
set encoding=UTF-8		" Use UTF-8 encoding
set foldenable			" Enable folding
set foldlevelstart=10	" Start folding after 10 lines
set foldmethod=indent	" Fold on indentation level
set foldnestmax=10		" Do not nest folding more than 10 times
set hidden				" Allow hiding of unsaved buffers
set history=1000		" Remember last 1000 commands
set hlsearch			" Highlight matches while searching
set incsearch			" Search as soon as characters are entered
set laststatus=2		" Always display status line
set lazyredraw			" Redraw only when needed
set modelines=1			" Use modelines
set noshowmode			" Do not show mode (lightline does so already)
set number				" Show line numbers
set pastetoggle=<F2>	" Toggle paste mode using F2 key
set shiftwidth=4		" Shift by 4 spaces for auto-indent
set showmatch			" Highlight matching braces
set smartindent			" Enable smart indentation
set softtabstop=4		" Set soft tab size to 4 spaces
set tabstop=4			" Set tab size to 4 spaces
set ttyfast				" Increase speed of redrawing
set wildmenu			" Enable visual autocomplete for commands
" }}}
" Plugin Manager {{{
call plug#begin()
	Plug 'joshdick/onedark.vim'
	Plug 'itchyny/lightline.vim'
	Plug 'scrooloose/nerdtree'
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
	Plug 'junegunn/fzf.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'
	Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}
" Theme Options {{{
if (empty($TMUX))
	if (has("nvim"))
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	if (has("termguicolors"))
		set termguicolors
	endif
endif

syntax on
colorscheme onedark
" }}}
" File Type Options {{{
filetype plugin on
filetype indent on
" }}}
" Key Bindings {{{
let mapleader=","			" Use comma as leader key
let maplocalleader="\\"		" Use backslash as local leader key

nnoremap <space> za
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>
nnoremap <leader>l :call ToggleLineNumbers()<CR>
nnoremap <C-n> :NERDTreeToggle<CR>

" FZF Bindings
nnoremap <leader><leader> :GFiles<CR>
nnoremap <leader><CR> :Buffers<CR>
nnoremap <leader>fi :Files<CR>
nnoremap <leader>fl :Lines<CR>
" }}}
" [Plugin] Lightline {{{

let g:lightline = {
			\ 'colorscheme': 'onedark',
			\ }
" }}}
" [Plugin] NERDTree {{{
let g:NERDTreeShowHidden=1
let g:NERDTreeIgnore=['.git$[[dir]]', '.swp']
" }}}
" Auto Commands {{{
augroup configgroup
	" Remove previous auto-commands and redraw Vim on startup
	autocmd!
	autocmd VimEnter * redraw!

	" Open NERDTree automatically when no files were specified
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
	autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
	autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
" }}}
" Custom Functions {{{
function! ToggleLineNumbers()
	if(&relativenumber == 1)
		set norelativenumber
		set number
	else
		set relativenumber
	endif
endfunction
" }}}

" vim:foldmethod=marker:foldlevel=0
