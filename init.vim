" Required tools : Git, ctags
:let s:ConfigDir = ''
":let s:FZFDir = ''
:let s:VimDir = ''

" {{{ Properties
"
" }}}

if has("win32")
  :let ConfigDir = $LOCALAPPDATA.'\nvim'
"  :let FZFDir = $USERPROFILE.'\.fzf'
  :let VimDir = $USERPROFILE.'\.vim'
elseif has("unix")
" [TODO] Do eventual implementation for unix environment
endif
" Neovim variant
function! CreateRequiredFolders(ConfigDir)
  :let AutoloadDir = a:ConfigDir . '\autoload'
  :let BundleDir = a:ConfigDir . '\bundle'
  :let ColorsDir = a:ConfigDir . '\colors'
  if !isdirectory(AutoloadDir)
	  :execute ":silent !mkdir " . AutoloadDir
  endif
  if !isdirectory(BundleDir)
	  :execute ":silent !mkdir " . BundleDir
  endif
  if !isdirectory(ColorsDir)
	  :execute ":silent !mkdir " . ColorsDir
  endif
endfunction

function! ConfigurePlugins(ConfigDir)
	" Download Pathogen (must be first)
	execute ':silent !curl -LSso ' . a:ConfigDir . '\autoload\pathogen.vim https://tpo.pe/pathogen.vim'
	" Download VimPlug
	execute ':silent !curl -LSso ' . a:ConfigDir . '\autoload\plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	" [DEPRECATED] Clone VimColorsSolarized doesnt work in current NeoVim version.
	" execute ':silent !cd /d ' . a:ConfigDir . '\bundle && git clone git://github.com/altercation/vim-colors-solarized.git'
	" Clone NerdTreeGitPlugin
	execute ':silent !cd /d ' . a:ConfigDir . '\bundle && git clone git://github.com/Xuyuanp/nerdtree-git-plugin.git'
	" Clone Vim Indent Guides
	execute ':silent !cd /d ' . a:ConfigDir . '\bundle && git clone git://github.com/nathanaelkane/vim-indent-guides.git'
	" Clone Lightline (status line)
	execute ':silent !cd /d ' . a:ConfigDir . '\bundle && git clone git://github.com/itchyny/lightline.vim'
endfunction

function! ConfigureColorSchemes(ColorDir)
	" Download a dark color scheme for vim.
	execute ':silent !curl -LSso ' . a:ColorDir . '\colors\janah.vim https://raw.githubusercontent.com/mhinz/vim-janah/master/colors/janah.vim'
endfunction

function! ConfigureFZF(ConfigDir)
endfunction

" [TODO] Make it better so it will replace CurtinIncSW
function! SwitchCorrespondingFile()
  if(expand('%:e')=='c' || expand('%:e')=='cpp')
    :tab drop %<.h
  elseif(expand('%:e')=='h' || expand('%:e')=='hpp')
    :tab drop %<.cpp
  endif
endfunction

:call CreateRequiredFolders(ConfigDir)
:call ConfigurePlugins(ConfigDir)
":call ConfigureFZF(FZFDir)
:call ConfigureColorSchemes(ConfigDir)

" Initiate pathogen
execute pathogen#infect()

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

"Plug 'altercation/vim-colors-solarized'

" https://github.com/junegunn/fzf.vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ericcurtin/CurtineIncSw.vim'
" ctag helper plugin. Disabled, it messes up the vim window.
"Plug 'ludovicchabant/vim-gutentags'
" Surround script
Plug 'tpope/vim-surround'

" Initialize plugin system
call plug#end()

" Use true color mode for GUI terminal, so that themes can be applied.
:set termguicolors

" Indentation settings
set tabstop=4
set shiftwidth=4
set expandtab

" Editor font properties
set guifont=consolas


" Display line numbers on the left
set number

" vim-colors-solarized properties
"syntax enable
"set background=dark
"colorscheme solarized

" vim-janah color scheme properties
colorscheme janah
" NERDTree properties

autocmd VimEnter * NERDTree | wincmd p

" Change "~" color on empty lines so it will blend with the background.
:hi NonText guifg=bg

" -=- Common Properties -=-
" Remaps
" Enable use of the mouse for all modes
set path+=**
set wildmenu
set mouse=a
map <ScreelWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
nnoremap <A-w> :call SwitchCorrespondingFile()<CR>
nnoremap <A-q> gT
nnoremap <A-e> gt
" ~=~ Common Properties ~=~

" -=- Plugin Properties -=-

	" -=- NERDTree Properties -=-
	" Remaps
	nnoremap <A-1> :NERDTree C:\<CR>
	nnoremap <A-2> :NERDTree D:\<CR>
    nnoremap <A-3> :NERDTree E:\<CR>
    nnoremap <A-4> :NERDTree F:\<CR>
" ~=~ Plugin Properties ~=~
	
" Window
:let g:NERDTreeWinSize = 60
" ~=~ NERDTree Properties ~=~
