" PLUGINS (Plug)
" =============

" Install vim-plug if we don't already have it.
if empty(glob("~/.vim/autoload/plug.vim"))
	" Ensure all needed directories exist.
	execute '!mkdir -p ~/.vim/plugged'
	execute '!mkdir -p ~/.vim/autoload'
	" Download the actual plugin manager.
	execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'

" Others
Plug 'tpope/vim-fugitive'              " git handling.
Plug 'tpope/vim-surround'              " surround text with delimiters.
Plug 'scrooloose/nerdtree'             " file list on the right.
"Plug 'scrooloose/syntastic'            " spell checker.
Plug 'w0rp/ale'                        " spell checker.
" The following plugin is disabled as it prevents syntastic from working.
"Plug 'xuyuanp/nerdtree-git-plugin'     " git gutter in NERDtree.
Plug 'bling/vim-airline'               " a bar.
Plug 'vim-airline/vim-airline-themes'  " and themes.
Plug 'airblade/vim-gitgutter'          " shows changes in gutter.
Plug 'christoomey/vim-tmux-navigator'  " intuitive Tmux integration.
Plug 'benmills/vimux'                  " open tmux pane to run scripts.
Plug 'Valloric/YouCompleteMe'          " spell completion.
"Plug 'raimondi/delimitmate'            " auto close brackets, parentheses...
Plug 'jiangmiao/auto-pairs'            " auto close brackets, parentheses...
Plug 'yuttie/comfortable-motion.vim'   " natural scroll.
"Plug 'junegunn/vim-easy-align'         " align code to the same column easily.
Plug 'junegunn/goyo.vim'               " zen mode.
Plug 'heavenshell/vim-pydocstring'     " add python docstrings.
Plug 'mileszs/ack.vim'                 " fast search in project.
Plug 'mhinz/vim-startify'              " a splash screen with recent files.
Plug 'kien/ctrlp.vim'                  " jump to files easily.
"Plug 'idbrii/AsyncCommand'             " run asynchronous commands.
"Plug 'stgpetrovic/syntastic-async'     " async Syntastic.
Plug 'thiagoalessio/rainbow_levels.vim'


" Other plugins require curl
if executable("curl")
    " Webapi: Dependency of Gist-vim
    Plug 'mattn/webapi-vim'

    " Gist: Post text to gist.github
    Plug 'mattn/gist-vim'
endif

filetype plugin indent on  " required!
call plug#end()

" Applied colorscheme
" Will work with Termite.
set t_Co=256  " for 256 terminal colors
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
set background=dark

" General stuff
set history=1000
set autoread  " set to autoread when a file is changed from the outside.
let mapleader = ","  " change the leader key.
let g:mapleader = ","
set so=7  " moves the window when reach the bottom of the screen.
set lazyredraw  " don't redraw while executing macros.
set showmatch  " show the corresponding bracket.
set mat=2  " how many tenths of a second to blink when matching brackets
syntax enable  " enable syntax highlighting.
set number  " display the line number.
let &colorcolumn=80  " shows the column 80
set foldcolumn=1  " add a bit of extra margin to the left.
set number relativenumber  " enables relative line numbers in the gutter.

" Precise stuff
set encoding=utf-8  " utf9 as standard encoding and en_US as standard language.
set ffs=unix,dos,mac  " unix as standard file type.

" Searching
set ignorecase  " ignore case whem searching
set smartcase  " be smart about case when searching.
set hlsearch  " highlight the search as it goes
set incsearch  " search directly from the comment we type.

" Remove sounds on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turns backup off so avoid conflicts with git.
set nobackup
set nowb
set noswapfile

" Editing
set expandtab  " spaces instead of tabs.
set smarttab  " be smart about tabs.
set shiftwidth=4
set tabstop=4  " 1 tab = 4 spaces
set lbr  " linebreak on 500 characters
set tw=500
set ai  " auto indent.
set si  " smart indent.
set wrap  " wrap lines.
try  " try to undo even when we closed the file earlier.
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

" Buffers
set hidden  " a buffer becomes hidden when it is abandonned.
map <leader>T :enew<cr>             " open a new empty buffer.
map <s-l> :bnext<cr>                " move to next buffer.
map <s-h> :bprevious<cr>            " move to previous buffer.
map <leader>k :bp <bar> bd #<cr>   " close the buffer and move to the previous
map <leader>K :bufdo bd<cr>        " close all buffers in the current tab.
map <leader>bs :ls<cr>              " show all opened buffers and their status.


" Moving
" =================================================
" Intuitive way of changing windows.
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-l> <C-W>l
map <C-k> <C-W>k
" Shortcuts to manage tabs.
map <leader>tn :tabnew<cr>
" Opens a new tab with the current buffer's path
    map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Remap Vim's 0 to first non blank character
map 0 ^
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


" General shortcuts
map <leader>pp :setlocal paste!<cr>  " togle paste mode.


" Python stuff
" ============================
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f #--- <esc>a
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 
au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#

" Tmux stuff
" ============================
if exists('$TMUX') 
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color 
    endif
endif


" NerdTree
" ============================
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


" Syntastic --- Has been replaced by Ale for this rice.
" ============================
"let g:syntastic_python_checkers=['pylint']
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 1
"
"let g:syntastic_loc_list_height=3  " smaller list of errors


" Airline
" ============================
let g:airline_theme='base16_ocean'
let g:airline#extensions#tabline#enabled = 1  " shows the buffer name at the top.
let g:airline#extensions#tabline#fnamemod = ':t'  " just keep the name of the file


"Ale
" ============================
let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'
nmap <silent> <leader>n <Plug>(ale_next_wrap)
nmap <silent> <leader>N <Plug>(ale_previous_wrap)


" Vimux
" ============================
let g:VimuxHeight = "15"  " change the default size of the window.
" Run the current script with python.
map <leader>rc :call VimuxRunCommand("clear; ipython " . bufname("%"))<cr>
" Run a given command
map <leader>rg :VimuxPromptCommand<cr>
" Repeat last command
map <leader>rr :VimuxRunLastCommand<cr>


" PyDocstring
" ============================
nmap <silent> <leader>d <Plug>(pydocstring)

" Ack
" ============================
" Don't jump to first result automatically
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" YouCompleteMe
" ============================
nnoremap <C-]> :YcmCompleter GoToDefinition<cr>


" Fugitive
" ============================
set diffopt+=vertical  " vertical Gdiff

