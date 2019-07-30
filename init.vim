" Required tools : Git, (Universal) ctags
"
:let ConfigDir = ''
:let VimDir = ''
:let VimPluginsDir = ''

if has("win32")
  :let ConfigDir = $LOCALAPPDATA.'\nvim'
  :let VimDir = $USERPROFILE.'\.vim'
  :let VimPluginsDir = VimDir. '\plugged'

elseif has("unix")
" [TODO] Do eventual implementation for unix environment
endif

:let PythonDir = ConfigDir.'\python'

" Neovim variant
function! CreateRequiredFolders(ConfigDir)
   :let AutoloadDir = a:ConfigDir . '\autoload'

  if !isdirectory(AutoloadDir)
	  :execute ":silent !mkdir " . AutoloadDir
  endif
endfunction

function! InitiateVimPlug(ConfigDir)  
    :let PlugPath = a:ConfigDir . '\autoload\plug.vim'

    " Download VimPlug
    if !filereadable(PlugPath)
    	execute ':silent !curl -LSso ' . PlugPath . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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

" [TODO] Make it better so it will replace CurtinIncSW
function! SwitchCorrespondingFile()
  if(expand('%:e')=='c' || expand('%:e')=='cpp')
    :tab drop %<.h
  elseif(expand('%:e')=='h' || expand('%:e')=='hpp')
    :tab drop %<.cpp
  endif
endfunction

:call CreateRequiredFolders(ConfigDir)
:call InitiateVimPlug(ConfigDir)

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Text editing plugin
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-janah'
Plug 'SirVer/ultisnips'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'


Plug 'Valloric/YouCompleteMe'
Plug 'kien/ctrlp.vim'
Plug 'ludovicchabant/vim-gutentags'
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Surround script
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
    " Absolute and relative line numbers
Plug 'jeffkreeftmeijer/vim-numbertoggle'

Plug 'nathanaelkane/vim-indent-guides'
Plug 'embear/vim-localvimrc'
" Initialize plugin system
call plug#end()

" Use true color mode for GUI terminal, so that themes can be applied.
:set termguicolors

" Indentation settings
set tabstop=4
set shiftwidth=4
set expandtab

" Editor font properties
set guifont=verdana


" Display line numbers on the left
set number

" vim-colors-solarized properties
"syntax enable
"set background=dark
"colorscheme solarized

" vim-janah color scheme properties
if isdirectory(VimPluginsDir. '\vim-janah')
	colorscheme janah
endif

" NERDTree properties
if isdirectory(VimPluginsDir. '\nerdtree')
	autocmd VimEnter * NERDTree | wincmd p
endif

" Change "~" color on empty lines so it will blend with the background.
:hi NonText guifg=bg

" -=- Common Properties -=-

" Remaps
" Enable use of the mouse for all modes
set path+=**
set wildmenu
set mouse=a
set encoding=utf-8
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
" Window
:let g:NERDTreeWinSize = 60
" Terminal
tnoremap <Esc> <C-\><C-n>

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
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'cra'
    let g:ctrlp_root_markers = ['.ctrlp']
    nnoremap <c-p><c-m> :CtrlP X:/_Workspace/Varsav/BeBee/Source<CR>
	nnoremap <c-p><c-g> :CtrlP C:/_Workspace/DreamPlant/Latest/Source<CR>
    nnoremap <c-p><c-v> :exec "CtrlP ".$MYVIMRC<CR>
    " ~=~ CtrlP Properties ~=~
    
	" -=- Universal ctags Properties -=-
    set tags+=C:/_Workspace/BeBee/Source/tags;
    set tags+=C:/_Engines/UE_4.20/Engine/Source/tags;
    " ~=~ Universal ctags Properties ~=~
	
	" -=- UltiSnips config -=-
	" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
	" Use 'pip install neovim' for ultisnips and youcompleteme to work.
	let g:UltiSnipsExpandTrigger="<c-tab>"
	let g:UltiSnipsJumpForwardTrigger="<c-b>"
	let g:UltiSnipsJumpBackwardTrigger="<c-z>"
	let g:UltiSnipsEditSplit="vertical"
	let g:UltiSnipsSnippetDirectories = [ConfigDir.'/ultisnips', 'UltiSnips']
	" ~=~ UltiSnips config ~=~
	
	" -=- YouCompleteMe config -=-
	let g:ycm_global_ycm_extra_conf = PythonDir.'/.ycm_extra_conf.py'
	" ~=~ YouCompleteMe config ~=~

    " -=- LocalVimRC config -=-
    "   Don't ask before loading a vimrc file.
    let g:localvimrc_ask=0
    "   Don't load vimrc file in a sandbox.
    let g:localvimrc_sandbox=0
	" ~=~ LocalVimRC config ~=~
    " { ColorCoded Config
    let g:color_coded_enabled = 1
    let g:color_coded_filetypes = ['c', 'cpp', 'h', 'hpp']
    " } ColorCoded Config
" ~=~ Plugin Properties ~=~

" -=- Python support commands -=-

python3 << EOL
import sys
import vim
import os

dependencies = os.path.abspath(vim.eval("g:PythonDir"))
sys.path.append(dependencies)

def CallFunc(*args):
	from common import scripts
	sys.args = args
	s = scripts.main()
EOL

command! -nargs=* P python3 CallFunc(<f-args>)
" ~=~ Python support commands ~=~


