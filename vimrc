" Setup {{{1
set nocompatible
filetype off

let plugins_dir_name   = '.vim/bundle'
let vimrc_path         = resolve(expand('<sfile>'))
let vimrc_dir          = fnamemodify(vimrc_path, ':h')
let plugins_dir        = '~/' . plugins_dir_name
let plugins_dir_exists = isdirectory(plugins_dir)
let vundle_dir         = plugins_dir . '/' . 'vundle'
let vundle_dir_exists  = isdirectory(vundle_dir)

if !vundle_dir_exists
	call mkdir(vundle_dir, 'p')
	let install_cmds = []

	call add(install_cmds, 'echo "Installing Vundle ..."')
	call add(install_cmds, 'git clone https://github.com/gmarik/vundle.git ' . vundle_dir)

	let install_cmd = ":silent !" . join(install_cmds, '  &&  ')
	execute install_cmd
endif

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Plugins {{{1
Plugin 'gmarik/vundle'
Plugin 'w0ng/vim-hybrid'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/syntastic'

" PHP, web dev, and WP
Plugin 'StanAngeloff/php.vim'
Plugin 'shawncplus/phpcomplete.vim'
Plugin 'joonty/vim-phpqa.git'
Plugin 'tpope/vim-markdown'
Plugin 'mattn/emmet-vim'
Plugin 'dsawardekar/wordpress.vim'

" Additional hacks.
Plugin 'junegunn/vim-easy-align'
Plugin 'christoomey/vim-sort-motion'
Plugin 'kshenoy/vim-signature' " Highlight marks.
Plugin 'airblade/vim-gitgutter' " Highlight GIT changes.
Plugin 'tpope/vim-surround'
Plugin 'dhruvasagar/vim-table-mode'

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
" set foldmethod=marker
set formatprg=par
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:▸\ ,eol:¬
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
set wildignore+=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam,*.pyc,node_modules/**
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
let g:airline_theme='hybrid'
let g:airline_powerline_fonts=1

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

" Functions {{{1
" PrettyJSON {{{2
command! -range=% JSON <line1>,<line2>call PrettyJSON()
fun! PrettyJSON() range
	exe a:firstline . "," . a:lastline . "!python2 -mjson.tool"
endfun

" Configure GIT
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" PHP Quality Check
let g:phpqa_php_cmd='/usr/bin/php'
let g:phpqa_codesniffer_cmd='/home/david/Programs/dev/workspaces/nelio/vagrant-local/www/phpcs/scripts/phpcs'
let g:phpqa_messdetector_cmd='/usr/bin/phpmd'
let g:phpqa_codesniffer_args = '-s --standard=.config/phpcs.ruleset.xml'

" }}} vim: fdm=marker
