" call plug#begin('~/.local/share/nvim/plugged')
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  

"  Plugins {{{
" Colorschemes {{{
  call dein#add('chriskempson/base16-vim')
"   call dein#add('rakr/vim-one')
"   call dein#add('joshdick/onedark.vim')
"   call dein#add('nanotech/jellybeans.vim')
"   call dein#add('KeitaNakamura/neodark.vim')
"   call dein#add('mhartington/oceanic-next')
"   call dein#add('jacoborus/tender.vim')
"   call dein#add('nightsense/snow')
  call dein#add('arcticicestudio/nord-vim')
  call dein#add('morhetz/gruvbox')
  call dein#add('ayu-theme/ayu-vim')
"   call dein#add('drewtempelmeyer/palenight.vim')
"   call dein#add('jdsimcoe/abstract.vim')
"   call dein#add('zacanger/angr.vim')
"   call dein#add('dylanaraps/wal.vim')
"  }}}


"  Typing assistance {{{
   call dein#add('machakann/vim-sandwich')          " surround text with delimiters.
   call dein#add('jiangmiao/auto-pairs')            " auto close brackets, parentheses...
   call dein#add('kkoomen/vim-doge') 
"   call dein#add('w0rp/ale')                        " spell checker.
"   call dein#add('SirVer/ultisnips')                " autoexpand preconfigured keystrokes
"   call dein#add('honza/vim-snippets')              " bank of defaults for ultisnips
"    call dein#add('Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins') }   " replaced by Coc
"  Coc {{{
  call dein#add('neoclide/coc.nvim', {'merged': 0, 'rev': 'release'})
  call dein#add('neoclide/coc-python') ", {'build': 'yarn install --frozen-lockfile'})
"   call dein#add('neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'})
"   call dein#add('neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'})
"  call dein#add('neoclide/coc-git')  
"   call dein#add('neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'})
"   call dein#add('neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'})
"   call dein#add('neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'})
"   call dein#add('weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'})
  "call dein#add('fannheyward/coc-pyright', {'merged': 0, 'rev': 'release'}) " , {'build': 'yarn install --frozen-lockfile'})
"   call dein#add('voldikss/coc-todolist', {'do': 'yarn install --frozen-lockfile'})
"  }}}
"  }}}
"  Git {{{
   call dein#add('tpope/vim-fugitive')              " git handling.
"   call dein#add('airblade/vim-gitgutter')          " shows changes in gutter.
"  }}}
"  Look {{{
  call dein#add('bling/vim-airline')               " a bar.
  call dein#add('vim-airline/vim-airline-themes')  " and themes.
  call dein#add('mhinz/vim-startify')              " a splash screen with recent files.
  call dein#add('junegunn/goyo.vim')               " zen mode.
"  }}}
"  Tmux {{{
  call dein#add('christoomey/vim-tmux-navigator')  " intuitive Tmux integration.
"   call dein#add('benmills/vimux')                  " open tmux pane to run scripts.
"  }}}
"  Search, navigation {{{
  call dein#add('scrooloose/nerdtree')             " file list on the right.
"   call dein#add('mileszs/ack.vim')                 " fast search in project.
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 }) 
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
  call dein#add('easymotion/vim-easymotion')                  " like emac')s snipe
  call dein#add('chaoren/vim-wordmotion')                     " HelloYou counts as 2 words
"   call dein#add('vifm/vifm.vim')                     " HelloYou counts as 2 words
"  }}}
"  Language specific {{{
  call dein#add('sbdchd/neoformat')                " use black or yapf or else (python)
  call dein#add('numirias/semshi')  " color syntax (python)
  call dein#add('Integralist/vim-mypy')  " mypy support from vim
  call dein#add('lervag/vimtex')                   " general tools for LaTeX
"   call dein#add('PotatoesMaster/i3-vim-syntax')    " color syntaxing for .config/i3/config
"   call dein#add('ekalinin/Dockerfile.vim')         " color syntaxing for Dockerfiles
  call dein#add('plasticboy/vim-markdown')         " general tools for Markdown
"  }}}
"  Journaling {{{
"   call dein#add('vimwiki/vimwiki')                 " manage a personal wiki from Vim
"   call dein#add('mattn/calendar-vim')              " pop up a calendar for daily journaling
"   call dein#add('vim-pandoc/vim-pandoc')           " interface for Pandoc
"   call dein#add('vim-pandoc/vim-pandoc-syntax')    " color-syntax files supported by Pandoc
"  
"  }}}
"  To categorize {{{
  call dein#add('nathanaelkane/vim-indent-guides')
"   call dein#add('janko-m/vim-test')                " utility to run tests
  call dein#add('tpope/vim-sensible')              " universal set of defaults
  call dein#add('google/vim-searchindex')          " display count of search
  call dein#add('sheerun/vim-polyglot')            " support for many languages
"  }}}
  call dein#add('preservim/nerdcommenter')             " file list on the right.
"  What is that? {{{
  call dein#add('raimondi/delimitmate')            " auto close brackets, parentheses...
  call dein#add('rbgrouleff/bclose.vim')           " closing a buffer doesn')t close window
  call dein#add('godlygeek/tabular')
"  }}}

"call plug#end()
" }}}

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on


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
"set foldcolumn=1  " add a bit of extra margin to the left.
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
"set tw=88  " linebreak after 88 chars
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
            \ 'args': ["--style='{column_limit: 88}'"],
            \ }
let g:neoformat_python_black = {
            \ 'exe': 'black',
            \ 'stdin': 1,
            \ 'args': ['-t py36', '-l 88', '-q', '-'],
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
let g:vimtex_compiler_latexmk = {
    \ 'options' : '-pdf -verbose -bibtex -file-line-error -synctex=1 --interaction=nonstopmode',
    \}
let g:tex_flavor = 'latex'
" }}}
" Markdown {{{
let g:markdown_folding = 1
let g:vim_markdown_folding_level = 3
let g:vim_markdown_folding_disabled = 1
" }}}
" }}}
 
" Typing assistance  {{{
" General  {{{
nmap <silent> <leader>P oimport ipdb; ipdb.set_trace()<Enter>pass<Esc>:w<CR>
nmap <silent> <leader>tr Otry:<Esc>jI    <Esc>o<Del>except:<Enter>import ipdb; ipdb.set_trace()<Enter>pass<Enter><Esc>:w<CR>
nmap <silent> <leader>tt OOfrom contexttimer import Timerowith Timer() as my_timer:gv>gvookbprint(my_timer
" }}}
"  Ultisnips  {{{
" let g:UltiSnipsExpandTrigger="<c-o>"
" let g:UltiSnipsJumpForwardTrigger="<c-o>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"  If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsSnippetsDir = $HOME."/.config/UltiSnips"
" let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/UltiSnips']
" let g:UltiSnipsEnableSnipMate = 0
"  Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)
" 
"  Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)
" 
"  Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'
" 
"  Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'
" 
"  Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" 
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" 
" let g:coc_snippet_next = '<tab>'

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
let g:ale_python_pylint_options = '--rcfile tox.ini'
" }}}
" Deoplete {{{
" let g:deoplete#enable_at_startup = 1
" autocmd CompleteDone * silent! pclose!
"  deoplete tab-complete (default doesn't use tab)
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" }}}
" Coc {{{
" General {{{
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
" inoremap <silent><expr> <c-space> coc#refresh()
"  
"  GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
" 
"  Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

"  Add (Neo)Vim's native statusline support.
"" NOTE: Please see `:h coc-status` for integrations with external plugins that
"" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"" }}}
"" Explorer {{{
"nmap <space>e :CocCommand explorer --toggle --position right --width 33<CR>
"
"let g:coc_explorer_global_presets = {
"\   '.vim': {
"\      'root-uri': '~/.vim',
"\   },
"\   'floating': {
"\      'position': 'floating',
"\   },
"\   'floatingLeftside': {
"\      'position': 'floating',
"\      'floating-position': 'left-center',
"\      'floating-width': 50,
"\   },
"\   'floatingRightside': {
"\      'position': 'floating',
"\      'floating-position': 'left-center',
"\      'floating-width': 50,
"\   },
"\   'simplify': {
"\     'file.child.template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
"\   }
"\ }
"
"" Use preset argument to open it
"nmap <space>ed :CocCommand explorer --preset .vim<CR>
"nmap <space>ef :CocCommand explorer --preset floating<CR>
"
"" List all presets
"nmap <space>el :CocList explPresets

" }}}
" }}}
" }}}
 
" Journaling {{{
" Vimwiki {{{
set nocompatible
filetype plugin on
syntax on
let g:vimwiki_list = [{'path': '~/git/notes/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
" Allowing for folds. Oh boy that was a ride :smirk:
let g:pandoc#filetypes#handled = ["pandoc", "markdown"] 
let g:pandoc#filetypes#pandoc_markdown = 1
let g:pandoc#folding#mode = ["syntax"]
let g:pandoc#modules#enabled = ["formatting", "folding"]
let g:pandoc#formatting#mode = "h"
                                                        
let g:vimwiki_folding='expr'                            
au FileType vimwiki set filetype=vimwiki.markdown       

autocmd FileType vimwiki.markdown setlocal foldenable foldlevel=3

let g:vimwiki_global_ext = 0
" }}}
" }}}
 
" Search, navigation {{{
" General {{{
set ignorecase   " ignore case whem searching
set smartcase    " be smart about case when searching.
set hlsearch     " highlight the search as it goes
set incsearch    " search directly from the comment we type.
" Intuitive way of changing splits.
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-l> <C-W>l
map <C-k> <C-W>k
" Easy resizing of the splits.
noremap <silent> <C-Left> :vertical resize +5<CR>
noremap <silent> <C-Right> :vertical resize -5<CR>
noremap <silent> <C-Up> :resize +5<CR>
noremap <silent> <C-Down> :resize -5<CR>
map <leader>tn :tabnew<cr>
" Opens a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Remap Vim's 0 to first non blank character
map 0 ^
" Easy navigation through long lines
nmap j gj
nmap k gk
" }}}
" NERDTree {{{
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden = 0
let NERDTreeIgnore = ['.pyc$', '__pycache__']
let g:NERDTreeWinSize = 33
map <leader>nn :NERDTreeToggle<cr>
map <leader>nf :NERDTreeFind<cr>
"autocmd vimenter * NERDTree  " automatically opens NERDTree when vim starts.
"autocmd VimEnter * wincmd p  " the focus was on NERDTree. Now it's on the code.
let g:NERDDefaultAlign = 'left'
" }}}
" Ack {{{
" Don't jump to first result automatically
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
let g:ackprg = 'ag --nogroup --nocolor --column'  " Actually replacing Ack by Ag
" }}}
" fzf {{{
nmap <leader>f :GFiles<CR>                                                             
nmap <leader>F :Lines<CR>                                                             
nmap <leader>b :Buffers<CR>  
nmap <leader>B :BLines<CR>  
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
"colorscheme wal
syntax on
set background=dark
" }}}
if (empty($TMUX))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  if (has("termguicolors"))
    " activate only when not using "wal" as colorscheme
    set termguicolors
  endif
endif
if exists('$TMUX') 
    if has('nvim')
        " activate only when not using "wal" as colorscheme
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
" Startify  {{{
" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]
" }}}
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
 
let g:vifm_embed_term=1
" Folds sections of this vimrc file.
set modelines=1
" vim:foldmethod=marker:foldlevel=0

vnoremap yc "+y<cr>            " copy a selection to clipboard
