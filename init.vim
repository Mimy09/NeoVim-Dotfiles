
" --- VIM SETTINGS --- "

set shada="'50,<1000,s100,:0,n~/.config/nvim/shada"

" SETTINGS ------------------------------------ {{{
let mapleader = " "             " map leader to Space
syntax on 		    	        " Enable highlighting
set number 		    	        " Shows line number
set number relativenumber       " Show the relative line number to the cursor
set cursorline 			        " Highlight the line the cursor is on
set cursorcolumn		        " Highlight the column the cursor is on
set incsearch 			        " Searching highlight matching characters as you type
set ignorecase 			        " Ignore case in search
set hlsearch 			        " Use highlighting when doing a search
set showmatch 			        " Show matching words during a search
set smartcase 			        " Override the ignorecase option if searching for capital letters
set showmode 			        " Show mode
set wildmenu 			        " Auto completion on TAB (for :commands)
set wildmode=list:longest 	    " *
set mouse=a 			        " Allow for mouse support in all modes
set viminfofile=/home/mitchell/.config/nvim/.nviminfo " Move .viminfo file from ~ to .config
set tabstop=4 			        " show existing tab with 4 spaces width
set shiftwidth=4 		        " when indenting with '>', use 4 spaces width
set expandtab 			        " On pressing tab, insert 4 spaces
set splitbelow                  " Horizontal splits will automatically be below
set splitright                  " Vertical splits will automatically be to the right
set encoding=UTF-8              " *
set foldmethod=marker
let g:termdebug_wide=1          " Set terminal to open in vertical split
packadd termdebug               " Enable gdb debugging
set scrolloff=10                " Keep cursors in the center of the screen
set makeprg=bz                  " For building via sm bazel

" Disable startup warnings for COC
let g:coc_disable_startup_warning = 1

" }}}

" PLUGINS ------------------------------------- {{{

call plug#begin()
    Plug 'tomasiser/vim-code-dark'                      " VSCode theme
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy search
    Plug 'junegunn/fzf.vim'                             " 
    Plug 'ap/vim-buftabline'                            " Shows buffers
    Plug 'bfrg/vim-cpp-modern'                          " Advanced Highlighting for code in c++
    Plug 'ryanoasis/vim-devicons'                       " Enables nerd font icons
    Plug 'rhysd/vim-clang-format'                       " Formats C++ to the clang standerd
    Plug 'xavierd/clang_complete'                       " C++ language server
    Plug 'terryma/vim-multiple-cursors'                 " Allows multiple line editing
    Plug 'airblade/vim-gitgutter'                       " Adds a gutter that shows what lines have been edited
    Plug 'psliwka/vim-smoothie'                         " Smooths the scrolling
    Plug 'neoclide/coc.nvim', {'branch': 'release'}     " Adds code completion for c++
call plug#end()

" Enable git gutter highlighting
autocmd VimEnter * GitGutterLineNrHighlightsEnable

" Set theme
colorscheme codedark

" Setup the scroll minimap
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1

" }}}

" VIMSCRIPT ----------------------------------- {{{

" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,cu,h,hpp,ch,java,scala let b:comment_leader = '//'
  autocmd FileType sh,ruby,python               let b:comment_leader = '#'
  autocmd FileType conf,fstab                   let b:comment_leader = '#'
  autocmd FileType tex                          let b:comment_leader = '%'
  autocmd FileType mail                         let b:comment_leader = '>'
  autocmd FileType vim                          let b:comment_leader = '"'
augroup END
noremap Kc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap Ku :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Set folding for vimrc
augroup filetype_vim
    autocmd!
        autocmd FileType vim setlocal foldmethod=marker
        autocmd FileType c setlocal foldmethod=marker
        autocmd FileType c setlocal foldmarker=#pragma\ region,#pragma\ endregion
augroup END

" Highlight extra whitespaces red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()

" Accessing Standard Library documentation using cppman
function! s:JbzCppMan()
    let old_isk = &iskeyword
    setl iskeyword+=:
    let str = expand("<cword>")
    let &l:iskeyword = old_isk
    execute 'Man ' . str
endfunction
command! JbzCppMan :call s:JbzCppMan()
au FileType cpp nnoremap <buffer>K :JbzCppMan<CR>

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        vertical new
        exec "vertical resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

let g:clang_library_path = "/usr/lib/llvm-10/lib/libclang.so.1"

" }}}

" BINDS --------------------------------------- {{{

" vim buffer show
set hidden
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprev<CR>`

" remove color from find
map ** :noh <CR>

" Moving between windows
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" Move lines up and down using arrow keys
nnoremap <C-down> :m .+1<CR>==
nnoremap <C-up> :m .-2<CR>==
inoremap <C-down> <Esc>:m .+1<CR>==gi
inoremap <C-up> <Esc>:m .-2<CR>==gi
vnoremap <C-down> :m '>+1<CR>gv=gv
vnoremap <C-up> :m '<-2<CR>gv=gv

" Copying to clipboard
nnoremap <Leader>y "+yy
nnoremap <Leader>p "+p

" C-v is used for pasting in win term
nnoremap q <C-v>

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(75)<CR>
inoremap <A-t> <Esc>:call TermToggle(75)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(75)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" Fzf mapping
nmap <C-p> :Files<CR>
nmap <C-B> :Buffers<CR>
nmap <Leader>bl :BLines<CR>
nmap <Leader>bh :History:<CR>
nmap <Leader>bg :History<CR>
nmap <Leader>. :Tags<CR>

" Cpp formating
nnoremap <S-f> :ClangFormat<CR>

" Vim editing
nnoremap <silent> <F6> :source %<CR>
nnoremap <silent> <F7> :e ~/.config/nvim/init.vim<CR>

" Vim Explorer
nnoremap <Leader>mv :Vexplore<CR>
nnoremap <Leader>mt :Texplore<CR>

" }}}

runtime coc.vim
