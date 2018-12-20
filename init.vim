" Required tools : Git, ctags
"
:let ConfigDir = ''
":let FZFDir = ''
:let VimDir = ''
:let LuaDir = ''

" {{{ Properties
"
" }}}

if has("win32")
  :let ConfigDir = $LOCALAPPDATA.'\nvim'
  :let VimDir = $USERPROFILE.'\.vim'
  :let LuaDir = ConfigDir.'\lua'
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
    :let NerdTreeID = 'nerdtree-git-plugin'
    :let VimIndentGuidesID = 'vim-indent-guides'
    :let CtrlpVimID = 'ctrlp.vim'
    
    :let PathogenPath = a:ConfigDir . '\autoload\pathogen.vim'
    :let PlugPath = a:ConfigDir . '\autoload\plug.vim'
    :let NerdTreeDir = a:ConfigDir . '\bundle\' . NerdTreeID
    :let VimIndentGuidesDir = a:ConfigDir . '\bundle\' . VimIndentGuidesID
    :let CtrlpVimDir = a:ConfigDir . '\bundle\' . CtrlpVimID

    if !filereadable(PathogenPath)
    	execute ':silent !curl -LSso ' . PathogenPath . ' https://tpo.pe/pathogen.vim'
    endif
    " Download VimPlug
    if !filereadable(PlugPath)
    	execute ':silent !curl -LSso ' . PlugPath . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
	" [DEPRECATED] Clone VimColorsSolarized doesnt work in current NeoVim version.
	" execute ':silent !cd /d ' . a:ConfigDir . '\bundle && git clone git://github.com/altercation/vim-colors-solarized.git'
	" Clone NerdTreeGitPlugin
    if !isdirectory(NerdTreeDir)
	    execute ':silent !cd /d '.a:ConfigDir.'\bundle && git clone git://github.com/Xuyuanp/'.NerdTreeID.'.git'
    endif
	" Clone Vim Indent Guides
    if !isdirectory(VimIndentGuidesDir)
    	execute ':silent !cd /d '.a:ConfigDir.'\bundle && git clone git://github.com/nathanaelkane/'.VimIndentGuidesID.'.git'
    endif
    " Clone Ctrlp Vim
    if !isdirectory(CtrlpVimDir)
        execute ':silent !cd /d '.a:ConfigDir.'\bundle && git clone https://github.com/ctrlpvim/'.CtrlpVimID.'.git'
    endif
endfunction

function! VerticalOpenOrCloseTerminal()
    :let l:TerminalWindowNumber = bufwinnr('\<\(term://\)')
    if(TerminalWindowNumber == -1)
        :split | terminal
        echo "Terminal window opened"
    else
        execute TerminalWindowNumber.'close'
        echo "Terminal window closed"
    end
endfunction

function! ConfigureColorSchemes(ColorDir)
	" Download a dark color scheme for vim.
	execute ':silent !curl -LSso ' . a:ColorDir . '\colors\janah.vim https://raw.githubusercontent.com/mhinz/vim-janah/master/colors/janah.vim'
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

Plug 'ericcurtin/CurtineIncSw.vim'
" Surround script
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
    " Absolute and relative line numbers
Plug 'jeffkreeftmeijer/vim-numbertoggle'

Plug 'arch1en/Configs', {'branch' : 'vim-lua-config'}
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
" Working dir will be the same as the file that is edited atm.
set autochdir
map <ScreelWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
nnoremap <silent> <A-w> :call SwitchCorrespondingFile()<CR>
nnoremap <A-q> gT
nnoremap <A-e> gt
nnoremap <C-s> :!ctags -a<CR> :w<CR>
nnoremap <silent> <A-t> :call VerticalOpenOrCloseTerminal()<CR>
nnoremap <A-T> :split<CR> :terminal<CR>
" -=- Terminal Properties -=-
tnoremap <Esc> <C-\><C-n>
" ~=~ Terminal Properties ~=~
" ~=~ Common Properties ~=~

" -=- Plugin Properties -=-

	" -=- NERDTree Properties -=-
	" Remaps
	nnoremap <A-1> :NERDTree C:\<CR>
	nnoremap <A-2> :NERDTree D:\<CR>
    nnoremap <A-3> :NERDTree E:\<CR>
    nnoremap <A-4> :NERDTree F:\<CR>
    " ~=~ NERDTree Properties ~=~
    " -=- CtrlP Properties -=-
    set runtimepath^=ConfigDir\bundle\plugin\ctrlp.vim
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'cra'
    " ~=~ CtrlP Properties ~=~
" ~=~ Plugin Properties ~=~
	
" Window
:let g:NERDTreeWinSize = 60
" ~=~ NERDTree Properties ~=~

" -=- Lua support commands -=-
function! s:ReloadLua(LuaDir, FileName)
	:execute 'luafile '.a:LuaDir.'\'.a:FileName.'.lua'
endfunction

command! -nargs=1 ReloadLua :call s:ReloadLua(LuaDir, <f-args>)
command! -nargs=1 Snip :lua require('init').snippet(<f-args>)
" ~=~ Lua support commands ~=~
