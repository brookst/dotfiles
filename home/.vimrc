set nocompatible
set notitle
set shiftwidth=4
set softtabstop=4
set expandtab
set cindent
set hlsearch
set list
set listchars=tab:>-
",eol:¶
set showcmd
set ruler
set incsearch
set smartcase
set wrap

"hi Comment ctermfg=lightblue
"hi Constant ctermfg=lightred
"hi Special ctermfg=lightred
"hi Type ctermfg=darkgreen
set background=dark

"toggle set paste option
set pastetoggle=<F2>

nnoremap <F5> :GundoToggle<CR>

"always show status line
set lazyredraw
set laststatus=2
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},
set statusline+=%{&ff}]%h%m%r%y(%b)%=%c,%l/%L\ %P\ %#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}%*

filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins
syntax on

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if $TERM ==? "linux"
  set t_Co=8
else
  set t_Co=256
endif

inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Right> <NOP>
inoremap <Left>  <NOP>
noremap <Up>     <NOP>
noremap <Down>   <NOP>
noremap <Right>  <NOP>
noremap <Left>   <NOP>
nmap j gj
nmap k gk
nmap <C-e> :e#<CR>
nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>
nmap ; :CtrlPBuffer<CR>
"map  :w!<CR>:!aspell check %<CR>:e! %<CR>

runtime bundle/vim-pathogen/autoload/pathogen.vim
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
call pathogen#infect()

let g:airline_powerline_fonts=1
let g:airline_section_a = '%{g:airline_current_mode_text} %{&paste ? "PASTE" : ""}'

"Versions prior to 701.040 don't have the method syntastic uses for
"highlighting
if !(v:version > 702 || v:version == 701 && has('patch040'))
    let g:syntastic_enable_highlighting = 0
endif

let g:syntastic_check_on_open=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol='✗'
let g:syntastic_style_warning_symbol='⚠'

let g:syntastic_cpp_config_file='.syntastic.conf'

" On by default, turn it off for html
let g:syntastic_mode_map = { 'mode': 'active',
        \ 'active_filetypes': [],
        \ 'passive_filetypes': ['html'] }
