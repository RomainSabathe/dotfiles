call plug#begin('~/.local/share/nvim/plugged')
 
" Plugins {{{
" Colorschemes {{{
Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'KeitaNakamura/neodark.vim'
Plug 'mhartington/oceanic-next'
Plug 'jacoborus/tender.vim'
Plug 'nightsense/snow'
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'ayu-theme/ayu-vim'
Plug 'drewtempelmeyer/palenight.vim'
" }}}
" Typing assistance {{{
Plug 'machakann/vim-sandwich'          " surround text with delimiters.
Plug 'jiangmiao/auto-pairs'            " auto close brackets, parentheses...
Plug 'w0rp/ale'                        " spell checker.
Plug 'SirVer/ultisnips'                " autoexpand preconfigured keystrokes
Plug 'honza/vim-snippets'              " bank of defaults for ultisnips
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }   " autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" }}}
" Git {{{
Plug 'tpope/vim-fugitive'              " git handling.
Plug 'airblade/vim-gitgutter'          " shows changes in gutter.
" }}}
" Look {{{
Plug 'bling/vim-airline'               " a bar.
Plug 'vim-airline/vim-airline-themes'  " and themes.
Plug 'mhinz/vim-startify'              " a splash screen with recent files.
Plug 'junegunn/goyo.vim'               " zen mode.
" }}}
" Tmux {{{
Plug 'christoomey/vim-tmux-navigator'  " intuitive Tmux integration.
Plug 'benmills/vimux'                  " open tmux pane to run scripts.
" }}}
" Search, navigation {{{
Plug 'scrooloose/nerdtree'             " file list on the right.
Plug 'mileszs/ack.vim'                 " fast search in project.
Plug 'kien/ctrlp.vim'                  " jump to files easily.
" }}}
" Language specific {{{
Plug 'sbdchd/neoformat'                " use black or yapf or else (python)
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}  " color syntax (python)
Plug 'lervag/vimtex'                   " general tools for LaTeX
Plug 'plasticboy/vim-markdown'         " general tools for Markdown
Plug 'PotatoesMaster/i3-vim-syntax'    " color syntaxing for .config/i3/config
Plug 'ekalinin/Dockerfile.vim'         " color syntaxing for Dockerfiles
" }}}
" Journaling {{{
Plug 'vimwiki/vimwiki'                 " manage a personal wiki from Vim
Plug 'mattn/calendar-vim'              " pop up a calendar for daily journaling
Plug 'vim-pandoc/vim-pandoc'           " interface for Pandoc
Plug 'vim-pandoc/vim-pandoc-syntax'    " color-syntax files supported by Pandoc
 
" }}}
" To categorize {{{
Plug 'nathanaelkane/vim-indent-guides'
Plug 'janko-m/vim-test'                " utility to run tests
Plug 'tpope/vim-sensible'              " universal set of defaults
Plug 'google/vim-searchindex'          " display count of search
Plug 'sheerun/vim-polyglot'            " support for many languages
" }}}
" What is that? {{{
Plug 'raimondi/delimitmate'            " auto close brackets, parentheses...
Plug 'rbgrouleff/bclose.vim'           " closing a buffer doesn't close window
Plug 'godlygeek/tabular'
" }}}

call plug#end()
" }}}

" General options  {{{
" general  {{{
set history=1000
set autoread  " set to autoread when a file is changed from the outside.
let mapleader = ","  " change the leader key.
let maplocalleader = ","  " change the leader key.
let g:mapleader = ","
set so=7  " moves the window when reach the bottom of the screen.
set lazyredraw  " don't redraw while executing macros.
set showmatch  " show the corresponding bracket.
set mat=2  " how many tenths of a second to blink when matching brackets
syntax enable  " enable syntax highlighting.
set number  " display the line number.
let &colorcolumn=88  " shows the column 88
set foldcolumn=1  " add a bit of extra margin to the left.
set number relativenumber  " enables relative line numbers in the gutter.
" }}}
" Sounds  {{{
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" }}}
" Editing  {{{
set expandtab  " spaces instead of tabs.
set smarttab  " be smart about tabs.
set shiftwidth=4
set tabstop=4  " 1 tab = 4 spaces
set lbr  " linebreak on 500 characters
set tw=88
set ai  " auto indent.
set si  " smart indent.
set wrap  " wrap lines.
try  " try to undo even when we closed the file earlier.
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry
" }}}
" Other  {{{
set encoding=utf-8  " utf9 as standard encoding and en_US as standard language.
set ffs=unix,dos,mac  " unix as standard file type.
" }}}
" }}}
 
" General mappings  {{{
" Buffers  {{{
set hidden                          " a buffer becomes hidden when it is abandonned.
map <leader>T :enew<cr>             " open a new empty buffer.
map <s-l> :bnext<cr>                " move to next buffer.
map <s-h> :bprevious<cr>            " move to previous buffer.
map <leader>k :bp <bar> bd #<cr>    " close the buffer and move to the previous
map <leader>K :bp <bar> bd! #<cr>   " close all buffers in the current tab.
map <leader>bs :ls<cr>              " show all opened buffers and their status.
" }}}
" Other  {{{
tnoremap <Esc> <C-\><C-n>            " escape terminal mode with Esc
map <leader>pp :setlocal paste!<cr>  " togle paste mode.
" }}}
" }}}
 
" Language specific {{{
" Python {{{
" General {{{
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#
" }}}
" Neoformat {{{
nmap <silent> <leader>ne :Neoformat<CR>:w<CR>
let g:neoformat_enabled_python = ['black', 'yapf', 'autopep8', 'pyment']
let g:neoformat_python_yapf = {
            \ 'exe': 'yapf',
            \ 'args': ["--style='{column_limit: 79}'"],
            \ }
let g:neoformat_python_black = {
            \ 'exe': 'black',
            \ 'stdin': 1,
            \ 'args': ['-t py36', '-l 79', '-q', '-'],
            \ }
let g:neoformat_python_pyment = {
            \ 'exe': 'pyment',
            \ 'stdin': 1,
            \ 'args': ['-w', '-o google', '-'],
            \ }
" }}}
" DVC {{{
autocmd! BufNewFile,BufRead Dvcfile,*.dvc setfiletype yaml<Paste>
" }}}
" }}}
" Latex {{{
let g:vimtex_view_method="zathura"
" }}}
" }}}
 
" Typing assistance  {{{
" General  {{{
nmap <silent> <leader>P oimport ipdb; ipdb.set_trace()<Enter>pass<Esc>:w<CR>
nmap <silent> <leader>tr Otry:<Esc>jI    <Esc>o<Del>except:<Enter>import ipdb; ipdb.set_trace()<Enter>pass<Enter><Esc>:w<CR>
nmap <silent> <leader>tt OOfrom contexttimer import Timerowith Timer() as my_timer:gv>gvookbprint(my_timer
" }}}
" Ultisnips  {{{
let g:UltiSnipsExpandTrigger="<c-o>"
let g:UltiSnipsJumpForwardTrigger="<c-o>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir = $HOME."/.config/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0
" }}}
" Ale  {{{
let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'
nmap <silent> <leader>n <Plug>(ale_next_wrap)
nmap <silent> <leader>N <Plug>(ale_previous_wrap)
" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', 'pylint']
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf']
" }}}
" Deoplete {{{
" let g:deoplete#enable_at_startup = 1
" autocmd CompleteDone * silent! pclose!
" " deoplete tab-complete (default doesn't use tab)
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" }}}
" Coc {{{
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
 
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" }}}
" }}}
 
" Journaling {{{
" Vimwiki {{{
set nocompatible
filetype plugin on
syntax on
let g:vimwiki_list = [{'path': '~/git/notes/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
" }}}
" }}}
 
" Search, navigation {{{
" General {{{
set ignorecase   " ignore case whem searching
set smartcase    " be smart about case when searching.
set hlsearch     " highlight the search as it goes
set incsearch    " search directly from the comment we type.
" Intuitive way of changing windows.
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-l> <C-W>l
map <C-k> <C-W>k
map <leader>tn :tabnew<cr>
" Opens a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Remap Vim's 0 to first non blank character
map 0 ^
" }}}
" NERDTree {{{
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden = 0
let NERDTreeIgnore = ['.pyc$', '__pycache__']
let g:NERDTreeWinSize = 33
map <leader>nn :NERDTreeToggle<cr>
map <leader>nf :NERDTreeFind<cr>
autocmd vimenter * NERDTree  " automatically opens NERDTree when vim starts.
autocmd VimEnter * wincmd p  " the focus was on NERDTree. Now it's on the code.
" Closes NERDTree if only 1 vim pane is remaining.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" Ack {{{
" Don't jump to first result automatically
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
" }}}
" CTRL-P {{{
set wildignore+=*.pyc
" }}}
 
" Look {{{
" Airline {{{
let g:airline_theme='base16_ocean'
let g:airline#extensions#tabline#enabled = 1  " shows the buffer name at the top.
let g:airline#extensions#tabline#fnamemod = ':t'  " just keep the name of the file
" }}}
" Colorscheme {{{
set t_Co=256  " for 256 terminal colors
let g:neodark#use_256color = 1
let g:neodark#solid_vertsplit = 1
let g:neodark#background = '#202020'
"colorscheme base16-gruvbox-dark-hard
colorscheme ayu
syntax on
set background=dark
" }}}
if (empty($TMUX))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  if (has("termguicolors"))
    set termguicolors
  endif
endif
if exists('$TMUX') 
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color 
    endif
endif
" }}}
" }}}
 
" Tmux {{{
" Vimux {{{
let g:VimuxHeight = "15"  " change the default size of the window.
" Run the current script with python.
map <leader>rc :call VimuxRunCommand("clear; ipython " . bufname("%"))<cr>
" Run a given command
map <leader>rg :VimuxPromptCommand<cr>
" Repeat last command
map <leader>rr :VimuxRunLastCommand<cr>
" }}}
" }}}
 
" Git {{{
" General {{{
" Turns backup off so avoid conflicts with git.
set nobackup
set nowb
set noswapfile
" }}}
" Fugitive {{{
set diffopt+=vertical  " vertical Gdiff
" }}}
" }}}
 
" Other  {{{
" Vimtest  {{{
let test#strategy = "vimux"  " run the tests in the Vimux window
let test#python#runner = 'pytest'
let test#python#pytest#executable = 'poetry run pytest'
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR> 
nmap <silent> <leader>ts :TestSuite<CR> 
nmap <silent> <leader>tl :TestLast<CR> 
nmap <silent> <leader>tv :TestVisit<CR>
" Useful functions  {{{
" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif
" }}}
" }}}
" }}}
 
" Folds sections of this vimrc file.
set modelines=1
" vim:foldmethod=marker:foldlevel=0
