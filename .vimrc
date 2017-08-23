" Vundle setup and plugins {{{
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
"
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
"
" Add all your plugins here (note older versions of Vundle used Bundle instead
" of Plugin)
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'maralla/completor.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
"Plugin 'davidhalter/jedi-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'junegunn/goyo.vim'
Plugin 'snipMate'
Plugin 'fholgado/minibufexpl.vim'
"Bundle 'Valloric/YouCompleteMe'
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"}}}

" Folding {{{
" Enable folding
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=10

" Enable folding with the spacebar
nnoremap <space> za
let g:SimpylFold_docstring_preview=1

" vimrc folding
augroup filetype_vim
    autocmd!
		autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}

" Indentation {{{
" shows what you are typing as a command
set showcmd
set autoindent
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>
" }}}

" Python {{{
" PEP8 indentation {{{
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set omnifunc=pythoncomplete#Complete
"}}}
" Unnecessary white {{{
highlight BadWhitespace ctermbg=red guibg=darkred
au BufWritePre *.py %s/\s\+$//e
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
"}}}
"}}}

" Auto-complete {{{
"let g:ycm_autoclose_preview_window_after_completion=1
"let g:ycm_auto_triggert=1
"let g:ycm_key_invoke_completion='<C-L>'
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
"let g:jedi#goto_command = "<leader>d"
"let g:jedi#goto_assignments_command = "<leader>g"
"let g:jedi#completions_command = "<C-L>"
"let g:jedi#show_call_signatures = "0"
"}}}

" UI {{{
if has("gui_macvim")
    let g:solarized_contrast="high"
    set background=dark
    colorscheme solarized
    colorscheme molokai
    set guifont=Monaco:h11
    set guioptions-=L
endif

set clipboard=unnamed

set cursorline
set cursorcolumn

set ruler
syntax on

" Relative/absolute line number {{{
set nu "line number
set rnu
autocmd InsertEnter * :set nornu
autocmd InsertLeave * :set rnu
"}}}

" Airline - power bar {{{
au VimEnter * exec 'AirlineTheme dark'
set laststatus=2
"}}}
"}}}

" Navigation {{{
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
"inoremap <silent> <Up> <Esc>gka
"inoremap <silent> <Down> <Esc>gja
"}}}

" Functions {{{
" Hard Mode {{{
function! HardMode()
  noremap <Up> <NOP>
  noremap <Down> <NOP>
  noremap <Left> <NOP>
  noremap <Right> <NOP>
endfunction
"}}}
" Set layout to Python IDE {{{
function! ToggleNERDTreeAndTagbar()
  let w:jumpbacktohere=1
  " Detect which plugins are open
  if exists('t:NERDTreeBufName')
    let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
  else
    let nerdtree_open = 0
  endif
  let tagbar_open = bufwinnr('__Tagbar__') != -1

  " Perform the appropriate action
  if nerdtree_open && tagbar_open
    NERDTreeClose
    TagbarClose
  elseif nerdtree_open
    TagbarOpen
    wincmd J
    wincmd k
    wincmd L
  elseif tagbar_open
    NERDTree
    wincmd J
    wincmd k
    wincmd L
  else
    NERDTree
    TagbarOpen
    wincmd J
    wincmd k
    wincmd L
  endif

  " Jump back to the original window
  for window in range(1, winnr('$'))
    execute window . 'wincmd w'
    if exists('w:jumpbacktohere')
      unlet w:jumpbacktohere
      break
    endif
  endfor  
endfunction
"}}}
"}}}

" Mappings {{{
nnoremap <silent> <F9> :exec 'w !ipython -i' shellescape(@%, 1)<cr>
nnoremap <silent> <F10> :exec 'w !ipython' shellescape(@%, 1)<cr>
" VimEnter * NERDTree | wincmd p
nnoremap <leader>\ :call ToggleNERDTreeAndTagbar()<CR>
" }}}

" Backup folders {{{
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
set writebackup
"}}}

" Search stuff {{{
set incsearch
set hlsearch
"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
"nnoremap <F3> :set hlsearch!<CR>
"}}}

" Auto commands {{{
" Automatically cd into the directory that the file is in
au FileType python set omnifunc=pythoncomplete#Complete
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')
set encoding=utf-8
let g:completor_python_binary = '/usr/local/bin/python3'
"}}}
