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

" Turn on terminal mouse support
set mouse=a

" Use British English
set spelllang=en_gb

" Toggle spellchecking
nmap <silent> <leader>s :set spell!<CR>

"hi Comment ctermfg=lightblue
"hi Constant ctermfg=lightred
"hi Special ctermfg=lightred
"hi Type ctermfg=darkgreen
set background=dark

"toggle set paste option
set pastetoggle=<F2>

" Vim doesn't set this under Windows for some reason
set backspace=indent,eol,start

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

" Resize splits when the window is resized
au VimResized * :wincmd =

" Reset wrap mode after diffing files
au FilterWritePre * if &diff | set wrap | endif

if $TERM ==? "linux"
  set t_Co=8
else
  set t_Co=256
endif

" Don't display push enter to contiune, just popopen the quicklist
function! Make()
  ccl
  silent make
  redraw!
  for i in getqflist()
    if i['valid']
      cwin
      winc p
      return
    endif
  endfor
endfunction

" " Call make silently
" nmap <silent> <leader>m :call Make()<CR>

nnoremap <F5> :call Make()<CR>
nnoremap <F6> :GundoToggle<CR>

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
"map  :w!<CR>:!aspell check %<CR>:e! %<CR>

runtime bundle/vim-pathogen/autoload/pathogen.vim
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
call pathogen#infect()

"Scratchpad from
"http://dhruvasagar.com/2014/03/11/creating-custom-scratch-buffers-in-vim
function! ScratchEdit(cmd, options)
    exe a:cmd tempname()
    setl buftype=nofile bufhidden=wipe nobuflisted
    if !empty(a:options) | exe 'setl' a:options | endif
endfunction

command! -bar -nargs=* Sedit call ScratchEdit('edit', <q-args>)
command! -bar -nargs=* Ssplit call ScratchEdit('split', <q-args>)
command! -bar -nargs=* Svsplit call ScratchEdit('vsplit', <q-args>)
command! -bar -nargs=* Stabedit call ScratchEdit('tabe', <q-args>)

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#example#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#redgreen#enabled = 1
" let g:airline_left_sep = '▙'
" let g:airline_right_sep = '▟'

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

let wiki_user = {}
let wiki_user.path = '~/vimwiki/'
" let wiki_user.html_template = '~/public_html/template.tpl'
let wiki_user.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}

let g:vimwiki_list = [wiki_user]
