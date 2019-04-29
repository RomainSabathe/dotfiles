" PLUGINS (Plug)
" =============

call plug#begin('~/.local/share/nvim/plugged')

" ----------------------------------------------------------------------------
" ----------------------------------------------------------------------------
" ----------------------------------------------------------------------------

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'KeitaNakamura/neodark.vim'
Plug 'mhartington/oceanic-next'
Plug 'jacoborus/tender.vim'

" Typing assistance
Plug 'tpope/vim-surround'              " surround text with delimiters.
"Plug 'Valloric/YouCompleteMe'          " spell completion.
Plug 'jiangmiao/auto-pairs'            " auto close brackets, parentheses...
Plug 'heavenshell/vim-pydocstring'     " add python docstrings.
Plug 'w0rp/ale'                        " spell checker.
Plug 'scrooloose/nerdcommenter'        "

" Git
Plug 'tpope/vim-fugitive'              " git handling.
Plug 'airblade/vim-gitgutter'          " shows changes in gutter.
Plug 'tommcdo/vim-fubitive'            " support for bitbucket

" Look
Plug 'bling/vim-airline'               " a bar.
Plug 'vim-airline/vim-airline-themes'  " and themes.
Plug 'mhinz/vim-startify'              " a splash screen with recent files.
Plug 'junegunn/goyo.vim'               " zen mode.

" Tmux
Plug 'christoomey/vim-tmux-navigator'  " intuitive Tmux integration.
Plug 'benmills/vimux'                  " open tmux pane to run scripts.
Plug 'tpope/vim-obsession'             " save vim sessions

" Search, navigation
Plug 'scrooloose/nerdtree'             " file list on the right.
Plug 'majutsushi/tagbar'               " navigation panel
Plug 'mileszs/ack.vim'                 " fast search in project.
Plug 'kien/ctrlp.vim'                  " jump to files easily.

" To categorize
Plug 'nathanaelkane/vim-indent-guides'
Plug 'janko-m/vim-test'                " utility to run tests
Plug 'tpope/vim-sensible'              " universal set of defaults
Plug 'google/vim-searchindex'          " display count of search
Plug 'sheerun/vim-polyglot'            " support for many languages

" Not used anymore
"Plug 'xuyuanp/nerdtree-git-plugin'    " git gutter in NERDtree.
"Plug 'scrooloose/syntastic'           " spell checker.
Plug 'raimondi/delimitmate'           " auto close brackets, parentheses...
"Plug 'yuttie/comfortable-motion.vim'  " natural scroll.
"Plug 'junegunn/vim-easy-align'        " align code to the same column easily.
"Plug 'idbrii/AsyncCommand'            " run asynchronous commands.
"Plug 'stgpetrovic/syntastic-async'    " async Syntastic.

" Async autocomplete module.
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
autocmd CompleteDone * silent! pclose!
" Use jedi engine inside deoplete
Plug 'deoplete-plugins/deoplete-jedi'
" Use tabnine engine inside deoplete (supposed to use machine learning)"
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

" Python stuff
Plug 'davidhalter/jedi-vim'  " Awesome functionality (go to definition, print docstrings etc)
Plug 'sbdchd/neoformat'
let g:neoformat_enabled_python = ['autopep8']

Plug 'ludovicchabant/vim-gutentags'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

let g:UltiSnipsExpandTrigger="<c-o>"
let g:UltiSnipsJumpForwardTrigger="<c-o>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir = $HOME."/.config/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0

" deoplete tab-complete (default doesn't use tab)
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" ----------------------------------------------------------------------------
" ----------------------------------------------------------------------------
" ----------------------------------------------------------------------------


" Other plugins require curl
if executable("curl")
    " Webapi: Dependency of Gist-vim
    Plug 'mattn/webapi-vim'

    " Gist: Post text to gist.github
    Plug 'mattn/gist-vim'
endif

filetype plugin indent on  " required!
call plug#end()

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

" ----------------------------------------------------------------------------
" Colorscheme
" ----------------------------------------------------------------------------

" Applied colorscheme
" Will work with Termite.
set t_Co=256  " for 256 terminal colors
""let g:onedark_termcolors=256
"silent! colorscheme onedark
syntax on
let g:neodark#use_256color = 1
let g:neodark#solid_vertsplit = 1
let g:neodark#background = '#202020'
"colorscheme neodark
colorscheme OceanicNext
"if filereadable(expand("~/.vimrc_background"))
"  let base16colorspace=256
"  source ~/.vimrc_background
"endif
set background=dark

""Credit joshdick
""Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
""If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
""(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
"if (empty($TMUX))
"  if (has("nvim"))
"  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"  endif
"  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
"  if (has("termguicolors"))
"    set termguicolors
"  endif
"endif


"set background=dark " for the dark version
"" set background=light " for the light version
"" colorscheme one

""set t_8b=^[[48;2;%lu;%lu;%lum
""set t_8f=^[[38;2;%lu;%lu;%lum

" ----------------------------------------------------------------------------
" Moving
" ----------------------------------------------------------------------------

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


" ----------------------------------------------------------------------------
" Python stuff
" ----------------------------------------------------------------------------

let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#
au FileType python set foldmethod=indent
au FileType python set foldlevel=0
"au FileType python set foldclose=all


" ----------------------------------------------------------------------------
" Tmux stuff
" ----------------------------------------------------------------------------

if exists('$TMUX') 
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color 
    endif
endif


" ----------------------------------------------------------------------------
" Tagbar
" ----------------------------------------------------------------------------

set updatetime=100  " Increase the refresh rate (default is 5000)
autocmd VimEnter * nested :TagbarOpen  " Autoopen tagbar
let g:tagbar_left = 1  " Put the bar on the left


" ----------------------------------------------------------------------------
" NerdTree
" ----------------------------------------------------------------------------

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


" ----------------------------------------------------------------------------
" Syntastic --- Has been replaced by Ale for this rice.
" ----------------------------------------------------------------------------

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


" ----------------------------------------------------------------------------
" Airline
" ----------------------------------------------------------------------------

let g:airline_theme='base16_ocean'
let g:airline#extensions#tabline#enabled = 1  " shows the buffer name at the top.
let g:airline#extensions#tabline#fnamemod = ':t'  " just keep the name of the file


" ----------------------------------------------------------------------------
"Ale
" ----------------------------------------------------------------------------

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
""let g:ale_python_flake8_executable = 'pipenv run'
""let g:ale_python_pylint_executable = 'pipenv run'


" ----------------------------------------------------------------------------
" Vimux
" ----------------------------------------------------------------------------

let g:VimuxHeight = "15"  " change the default size of the window.
" Run the current script with python.
map <leader>rc :call VimuxRunCommand("clear; ipython " . bufname("%"))<cr>
" Run a given command
map <leader>rg :VimuxPromptCommand<cr>
" Repeat last command
map <leader>rr :VimuxRunLastCommand<cr>


" ----------------------------------------------------------------------------
" PyDocstring
" ----------------------------------------------------------------------------

nmap <silent> <leader>d <Plug>(pydocstring)


" ----------------------------------------------------------------------------
" Ack
" ----------------------------------------------------------------------------

" Don't jump to first result automatically
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>


" ----------------------------------------------------------------------------
" YouCompleteMe
" ----------------------------------------------------------------------------

nnoremap <C-]> :YcmCompleter GoToDefinition<cr>


" ----------------------------------------------------------------------------
" Fugitive
" ----------------------------------------------------------------------------

set diffopt+=vertical  " vertical Gdiff


" ----------------------------------------------------------------------------
" Ctrl-p
" ----------------------------------------------------------------------------

set wildignore+=*.pyc


" ----------------------------------------------------------------------------
" Vim test
" ----------------------------------------------------------------------------

let test#strategy = "vimux"  " run the tests in the Vimux window
let test#python#runner = 'pytest'
let test#python#pytest#executable = 'pipenv run pytest'
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR> 
nmap <silent> <leader>ts :TestSuite<CR> 
nmap <silent> <leader>tl :TestLast<CR> 
nmap <silent> <leader>tv :TestVisit<CR>

nmap <silent> <leader>P oimport ipdb; ipdb.set_trace()<Enter>pass<Esc>:w<CR>
nmap <silent> <leader>tr Otry:<Esc>jI    <Esc>o<Del>except:<Enter>import ipdb; ipdb.set_trace()<Enter>pass<Enter><Esc>:w<CR>
""nmap <silent> <leader>tr Otry:j>>okbexcept:import ipdb; ipdb.set_trace()passkkk:w
nmap <silent> <leader>tt OOfrom contexttimer import Timerowith Timer() as my_timer:gv>gvookbprint(my_timer
