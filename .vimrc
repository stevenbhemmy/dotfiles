""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto load changes to vimrc files to open sessions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END


call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'

Plug 'ericbn/vim-solarized'
Plug 'kien/ctrlp.vim'
Plug 'd11wtq/ctrlp_bdelete.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

" Color and highlighting
syntax enable
set background=dark
set termguicolors
colorscheme solarized

" Airline settings
" let g:airline_powerline_fonts = 1
function! AirlineInit()
    let g:airline_section_a = airline#section#create(['mode'])
    let g:airline_section_b = airline#section#create_left(['branch'])
    let g:airline_section_c = airline#section#create(['paste'])
    let g:airline_section_x = airline#section#create(['ffenc'])
    let g:airline_section_y = airline#section#create(['filetype'])
endfunction
augroup airline_autocmd
   autocmd!
   autocmd BufEnter * AirlineRefresh
augroup END


" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 0
" CtrlP buffer delete enable
call ctrlp_bdelete#init()

" ensure vim-jinja is working
augroup jinja-syntax
    au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stmi,*.jinja set ft=jinja
augroup END

" Use Exuberant Ctags with YouCompleteMe
let g:ycm_collect_identifiers_from_tags_files = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Explorer alias
cnoreabbrev E Explore
let g:netrw_liststyle=3

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu
set wildmode=list:longest,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/tmp*,*.s,*.swp,*.zip,*.tar,*.tar.*

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Press F2 to ensure pasted text is not changed
set pastetoggle=<F2>

" Change gutter with Ctrl-n
set number
nnoremap <C-n> :set relativenumber!<cr>
augroup gutter
    autocmd!
    autocmd WinEnter * :set relativenumber
    autocmd WinLeave * :let &relativenumber=0
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs (should only be for python)
autocmd Filetype python setlocal expandtab

" Be smart when using tabs ;)
set smarttab


" 1 tab == 4 spaces
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

function! Formatonsave()
  let l:formatdiff = 1
  pyf /usr/share/clang/clang-format-18/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()
