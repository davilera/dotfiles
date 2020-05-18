" Setup {{{1
set nocompatible
filetype off

let vimrc_path         = '/home/david/.vimrc'
let vimrc_dir          = '/home/david'
let plugins_dir_name   = '.vim/bundle'
let plugins_dir        = '/home/david/' . plugins_dir_name
let vundle_dir         = plugins_dir . '/' . 'vundle'

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Plugins {{{1
Plugin 'gmarik/vundle'
Plugin 'w0ng/vim-hybrid'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'editorconfig/editorconfig-vim'

Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/syntastic'
Plugin 'davilera/syntastic-wp-scripts'

Plugin 'nicwest/vim-camelsnek'
Plugin 'tpope/vim-surround'
Plugin 'junegunn/vim-easy-align'
Plugin 'kshenoy/vim-signature'

" Web Development
Plugin 'StanAngeloff/php.vim'
Plugin 'shawncplus/phpcomplete.vim'
Plugin 'tpope/vim-markdown'
Plugin 'mattn/emmet-vim'
Plugin 'dsawardekar/wordpress.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'ElmCast/elm-vim'
Plugin 'prettier/vim-prettier'

filetype plugin indent on
syntax enable

" Options {{{1
set autoindent
set backspace=indent,eol,start
set backupdir=/tmp
set dictionary=~/.vim/spell/eng.utf-8.add
set directory=/tmp
set encoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac
set formatprg=par
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:▸\ ,eol:¬,space:·
set modelines=0
set noequalalways
set nomodeline
set number
set path+=**
set relativenumber
set ruler
set scrolloff=5
set shiftwidth=2
set shortmess=filnxtToOI
set showcmd
set smartcase
set smartindent
set spelllang=eng
set splitbelow
set splitright
set synmaxcol=512
set t_Co=256
set tabstop=2
set timeout
set timeoutlen=500
set ttimeoutlen=500
set ttyfast
set undolevels=100
set viminfo='10,\"100,:20,%,n~/.viminfo
set visualbell t_vb=".
set wildignore+=.svn,CVS,.git,node_modules,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam,*.pyc,*.min.js,*.min.css
set wildmode=list:longest,list:full
set wrap
set wrapmargin=0

" Necessary order
set linebreak
set textwidth=0
set display=lastline

" GUI settings {{{1
vnoremap <C-c> "+ygv"*y
nnoremap <C-t> :tabnew<cr>
nnoremap <RightMouse> "+]p

silent! colorscheme hybrid
silent! set background=dark
let g:airline_theme = 'hybrid'
let g:airline_powerline_fonts = 1

" Leaders {{{1
" Nothing here

" Autocommands {{{1
" Highlight trailing whitespace " {{{2
highlight ExtraWhitespace guibg=#bd5353 ctermbg=131
augroup whitespace
	au!
	au ColorScheme * highlight ExtraWhitespace guibg=#bd5353 ctermbg=131
	au BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t/
	au BufWrite * match ExtraWhitespace /\s\+$\| \+\ze\t/
augroup end

" Plugins {{{1
" easy-align {{{2
vmap <C-a> <Plug>(EasyAlign)

" Capitalization
let g:camelsnek_alternative_camel_commands = 1

" vim-surround {{{2
let g:surround_42 = "**\r**"
nnoremap ** :exe "norm v$hS*"<cr>
nnoremap __ :exe "norm v$hS_"<cr>
vmap * S*
vmap _ S_
vmap <leader>l <Plug>VSurround]%a(<C-r><C-p>+)<Esc>

" Emmet
let g:user_emmet_mode='a'
let g:user_emmet_install_global = 0
autocmd FileType html,css,php EmmetInstall

" WordPress
let g:wordpress_vim_wordpress_path = './.lando/wordpress'

" Functions {{{1
" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['wpscripts']
let g:syntastic_css_checkers = ['wpscripts']
let g:syntastic_scss_checkers = ['wpscripts']
let g:syntastic_php_phpcs = './vendor/bin/phpcs'
let g:syntastic_php_phpcs_args = '--standard=phpcs.ruleset.xml'

" }}}
