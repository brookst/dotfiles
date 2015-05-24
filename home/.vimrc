set nocompatible
set notitle
set shiftwidth=4
set softtabstop=4
set expandtab
set cindent
set hlsearch
set list
set listchars=tab:▸-
",trail:¶
",eol:¶
set showcmd
set ruler
set incsearch
set ignorecase
set smartcase
set wrap
set tags+=~/stl.tags
set scrolloff=5
set equalalways

if version >= 703
    if exists("&undodir")
        set undodir=~/.vim/undo/
    endif
    set undofile
    set undoreload=10000
endif
set undolevels=10000

" Turn on terminal mouse support
set mouse=a

" Use British English
set spelllang=en_gb

" Match multiple times per line
set gdefault

" Use <space> as <leader>
nnoremap <space> <nop>
let mapleader=" "

" Fix obvious spelling mistake
nnoremap <leader>z 1z=

" nnoremap <silent> <leader>s :set spell!<CR>
nnoremap <leader>t :Test<CR>

" Toggle highlighting
nnoremap <silent> <leader>n :nohl<CR>

" Window movements
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Resolve a symlink and point buffer at target
" see https://github.com/tpope/vim-fugitive/issues/147#issuecomment-47286687
nnoremap <leader>f :exec "file ". resolve(expand('%:p'))<CR>:e<CR>

" Disable these plugins if invoked as less
let g:pathogen_disabled = ['vim-css-color']
if exists("loaded_less")
    call add(g:pathogen_disabled, 'vim-surround')
    call add(g:pathogen_disabled, 'vim-speeddating')
    call add(g:pathogen_disabled, 'vim-yankstack')
endif

" Use vim-surround to wrap a word e.g. after adding a print
nnoremap <silent> <leader>s) :normal lysw)h<CR>
nnoremap <silent> <leader>s] :normal lysw]h<CR>
nnoremap <silent> <leader>s} :normal lysw}h<CR>
nnoremap <silent> <leader>s" :normal lysw"h<CR>
nnoremap <silent> <leader>S) :normal lys$)h<CR>
nnoremap <silent> <leader>S] :normal lys$]h<CR>
nnoremap <silent> <leader>S} :normal lys$}h<CR>
nnoremap <silent> <leader>S" :normal lys$"h<CR>

" Use <tab> to match bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" Easier map for switching to last used buffer
nnoremap <BS> <C-^>

" Mappings for incsearch.vim
if v:version > 703
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
endif

" Highlight 81st column
if v:version > 700
    hi ColorColumn ctermbg=red
    au BufWinEnter *.py let w:long=matchadd('ColorColumn', '\%81v', 100)
    hi Pmenu      ctermfg=15 ctermbg=70
    hi PmenuSel   ctermfg=15  ctermbg=27
    hi PmenuSbar  ctermfg=7  ctermbg=0
    hi PmenuThumb ctermfg=15  ctermbg=27
endif

" Break lines with the same indentation as their beginning
hi ColorColumn ctermbg=red
if v:version > 704 || v:version == 704 && has("patch338")
    set breakindent
endif
set showbreak=↪

" Line numbering
set number
if v:version > 703 && !exists("loaded_less")
    autocmd WinLeave * set norelativenumber
    autocmd WinEnter * if &ft != "help" | set relativenumber
    " The above doesn't fire if there is only one window
    autocmd VimEnter * set relativenumber
endif

au BufEnter * set title | let &titlestring = "@" . substitute(hostname(), ".*-", "", "") . ":" . substitute(expand("%:p"), "/home/brooks", "~", "")
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

hi DiffAdd ctermfg=15 ctermbg=70
hi DiffChange ctermfg=15 ctermbg=166
hi DiffDelete ctermfg=15 ctermbg=88
hi LineNr ctermbg=237
hi LineNr ctermfg=144
hi CursorLineNr ctermfg=15 ctermbg=darkgrey

hi clear SpellBad
hi clear SpellCap
hi clear SpellLocal
hi clear SpellRare
hi SpellBad cterm=standout,undercurl
hi SpellCap cterm=standout
hi SpellLocal cterm=standout
hi SpellRare cterm=undercurl
hi RedOnRed cterm=standout
hi WhiteOnRed ctermfg=white ctermbg=darkred
" Test. this is an uncapitalized sentance.

" Differentiate next search item
if v:version > 700
  function! HLNext (blinktime)
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#'.@/
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
  endfunction
  nnoremap <silent> n n:call HLNext(0.2)<cr>
  nnoremap <silent> N N:call HLNext(0.2)<cr>
endif

" Use repeat.vim to map cp to a repeatable xp
nnoremap <silent> <Plug>TransposeCharacters xp
\:call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters

" Map unimpaired's paste toggle to work at the head of a file
nmap yp yo<BS>

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
" set statusline=%t[%{strlen(&fenc)?&fenc:'none'},
" set statusline+=%{&ff}]%h%m%r%y(%b)%=%c,%l/%L\ %P\ %#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}%*

filetype on            " enables file type detection
filetype plugin on     " enables file type specific plugins
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
  set ttymouse=xterm2
endif

" Don't display push enter to continue, just pop open the quicklist
function! Make()
  ccl
  silent make
  redraw!
"   for i in getqflist()
"     if i['valid']
"       cwin
"       winc p
"       return
"     endif
"   endfor
endfunction

" " Call make silently
" nmap <silent> <leader>m :call Make()<CR>

nnoremap <F5> :call Make()<CR>
nnoremap <F6> :GundoToggle<CR>

"Insert date in insert mode
inoremap <C-D>   <C-R>=strftime('%F')." "<CR>

"Insert file name
inoremap <C-f>   <C-r>=expand("%:t:r")<CR>

"Unmap arrow keys
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Right> <NOP>
inoremap <Left>  <NOP>
noremap <Up>     <NOP>
noremap <Down>   <NOP>
noremap <Right>  <NOP>
noremap <Left>   <NOP>

"Remap line movements to traverse wrapped segments
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

nnoremap <C-e> :e#<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>
"map  :w!<CR>:!aspell check %<CR>:e! %<CR>

let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 's', 'x', 'X', 'y', 'Y']

" These plugins don't seem to work with vim 700
if v:version < 701
    call add(g:pathogen_disabled, 'vim-signify')
    call add(g:pathogen_disabled, 'vim-dispatch')
    call add(g:pathogen_disabled, 'vim-fugitive')
    call add(g:pathogen_disabled, 'vim-yankstack')
endif

runtime bundle/vim-pathogen/autoload/pathogen.vim
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
call pathogen#infect()

let g:jellybeans_background_color = "000000"
let g:jellybeans_background_color_256 = "000"
silent! colorscheme jellybeans

nmap <leader>p <Plug>yankstack_substitute_newer_paste
nmap <leader>P <Plug>yankstack_substitute_older_paste

"Execute commands after cursor, with some reference from:
"http://stackoverflow.com/questions/26884104/
function! CutAndRunNormal()
    normal! D
    normal @"
endfunction

nnoremap <leader>e :call CutAndRunNormal()<CR><Esc>

"Scratchpad from
"http://dhruvasagar.com/2014/03/11/creating-custom-scratch-buffers-in-vim
function! ScratchEdit(cmd, options)
    exe a:cmd tempname()
    setl buftype=nofile bufhidden=wipe nobuflisted
    if !empty(a:options) | exe 'setl' a:options | endif
endfunction

command! Gutter set invnumber | set invrelativenumber | SignifyToggle
nmap <silent> gh :Gutter<CR>

command! -bar -nargs=* Sedit call ScratchEdit('edit', <q-args>)
command! -bar -nargs=* Ssplit call ScratchEdit('split', <q-args>)
command! -bar -nargs=* Svsplit call ScratchEdit('vsplit', <q-args>)
command! -bar -nargs=* Stabedit call ScratchEdit('tabe', <q-args>)

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#example#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#redgreen#enabled = 1
let g:airline_theme="jellybeans"
" let g:airline_left_sep = '▙'
" let g:airline_right_sep = '▟'

"Versions prior to 701.040 don't have the method syntastic uses for
"highlighting
if v:version < 701 || v:version == 701 && !has('patch040')
    let g:syntastic_enable_highlighting = 0
endif

let g:better_whitespace_filetypes_blacklist=['help']

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
let wiki_user.diary_rel_path = ''
let wiki_user.template_path = '~/vimwiki/templates/'
let wiki_user.template_default = 'default'
let wiki_user.template_ext = '.html'
let wiki_user.path_html = '~/vimwiki_html/'
let wiki_user.css_name = '~/vimwiki/style.css'
let wiki_user.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'c': 'c', 'rust': 'rust', 'sql': 'sql', 'javascript': 'javascript', 'sh': 'sh', 'conf': 'conf', 'ssh': 'python', 'yaml': 'yaml', 'md': 'markdown'}

" Handler for precise linking
let g:vimwiki_list = [wiki_user]
function! VimwikiWikiIncludeHandler(value)
    let url = matchstr(a:value, g:vimwiki_rxWikiInclMatchUrl)
    let desc = matchstr(a:value, '{{.*|\zs\%([^|}]*\)\ze}}')
    if url[0] == '.'
        let url = url[1:]
        return '<a href="'.url.'">'.desc.'</a>'
    endif
    return ''
endfunction
