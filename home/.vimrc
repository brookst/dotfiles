set nocompatible
set notitle
set nojoinspaces
set shiftwidth=4
set softtabstop=4
set expandtab
set cindent
set hlsearch
set list
set listchars=tab:▸-
",trail:¶
",eol:¶
set fillchars=vert:│,diff:─
set showcmd
set ruler
set incsearch
set ignorecase
set infercase
set smartcase
set wrap
set splitright
set splitbelow
set tags+=~/stl.tags
set scrolloff=5
set equalalways
set wildmenu

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

" GNU screen sometimes borks dragging in 'xterm' mode
" See: http://stackoverflow.com/questions/8939043/gnu-screen-and-vim-adjusting-the-split-window-buffer-size-with-mouse
if !has("nvim")
    set ttymouse=xterm2
endif

if has("nvim")
    set inccommand=nosplit
endif

" Use British English
set spelllang=en_gb

" Match multiple times per line
set gdefault

set winaltkeys=no
if has("nvim") || has("gui")
    " let alt 'send' ESC key: https://github.com/neovim/neovim/issues/2088#issuecomment-171921470
    let s:printable_ascii = map(range(32, 126), 'nr2char(v:val)')
    call remove(s:printable_ascii, 92)
    for s:char in s:printable_ascii
        execute "inoremap <A-" . s:char . "> <Esc>" . s:char
    endfor
    unlet s:printable_ascii s:char"
    execute "inoremap <A-SPACE> <Esc><SPACE>"
endif

if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

" Use <space> as <leader>
nnoremap <space> <nop>
let mapleader=" "

" Fix obvious spelling mistake
nnoremap <leader>z 1z=

" nnoremap <silent> <leader>s :set spell!<CR>
nnoremap <leader>t :Test<CR>

" Toggle highlighting
nnoremap <silent> <leader>n :nohl<CR>

nnoremap <leader>r :%s//<left>

" Window movements
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Add typical directories to path
set path+=src,inc,include,

" Resolve a symlink and point buffer at target
" see https://github.com/tpope/vim-fugitive/issues/147#issuecomment-47286687
nnoremap <leader>f :exec "file ". resolve(expand('%:p'))<CR>:e<CR>

" Vimwiki bullet point a line
nnoremap <leader>* ^i	* <esc>l

imap <silent> <C-<> <Plug>VimwikiDecreaseLvlSingleItem
imap <silent> <C->> <Plug>VimwikiIncreaseLvlSingleItem

" Disable these plugins if invoked as less
let g:pathogen_disabled = ['vim-css-color']
if exists("loaded_less")
    call add(g:pathogen_disabled, 'vim-surround')
    call add(g:pathogen_disabled, 'vim-speeddating')
    call add(g:pathogen_disabled, 'vim-yankstack')
endif
if !has('nvim')
    call add(g:pathogen_disabled, 'LanguageClient-neovim')
else
    let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
            \ }
endif
let g:lsc_server_commands = {
        \ 'python': 'pyls',
        \ 'rust': 'rls',
        \ 'cpp': {
            \ 'command': 'clangd',
            \ 'suppress_stderr': v:true,
            \ },
        \ }
let g:lsc_auto_map = {'defaults': v:true,
        \ 'NextReference': '',
        \ 'PreviousReference': '',
        \ }

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

function! PostEnter()
    " Mappings for incsearch.vim
    if exists(':IncSearchMap')
        map /  <Plug>(incsearch-forward)
        map ?  <Plug>(incsearch-backward)
        map g/ <Plug>(incsearch-stay)
    endif
    redraw
endfunction
au VimEnter * call PostEnter()

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

augroup VimReload
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

if &term =~ "screen"
    set t_ts=k
    set t_fs=\
    " set t_AF=[3%p1%dm]
    " set t_AB=[4%p1%dm]
    " set t_AF=[%?%p1%{8}%<%t3%p1%d%e%p1%{16}%<%t9%p1%{8}%-%d%e38;5;%p1%d%;m
    " set t_AB=[%?%p1%{8}%<%t4%p1%d%e%p1%{16}%<%t10%p1%{8}%-%d%e48;5;%p1%d%;m
endif

" Default to bash, not kornshell
let g:is_bash = 1

" Default to LaTeX, not plain TeX
let g:tex_flavor = "latex"

let g:ttyname = substitute($PROMPT_COMMAND, "newline.*print_titlebar ", "", "")
if g:ttyname != ''
    let g:ttyname = substitute(g:ttyname, "$(PWD)", "", "")
    let g:ttyname = substitute(g:ttyname, '.*;\"\(.*\)\"', '\1', '')
endif
let g:ttyname = substitute(g:ttyname, "\"", "", "g")

au BufEnter * set title | let &titlestring = g:ttyname . substitute(expand("%:p"), "/home/brooks", "~", "")

augroup filetype
    au! BufNewFile,BufReadPost *.md set filetype=markdown
    au! BufRead,BufNewFile *.plt    set filetype=gnuplot
augroup END

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
set synmaxcol=300

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Resize splits when the window is resized
au VimResized * :wincmd =

" Reset wrap mode after diffing files
au FilterWritePre * if &diff | set wrap | endif

if $TERM ==? "linux"
  set t_Co=8
endif

" Split line to complement `J`
" https://www.reddit.com/r/vim/comments/3g8y3r
function! BreakHere()
    s/\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\r\3\5
    call histdel("/", -1)
endfunction

nnoremap S :call BreakHere()<CR>

" Use repeat.vim to map S
" nnoremap <silent> <Plug>BreakHere s<CR>
" \:call repeat#set("\<Plug>BreakHere")<CR>
" nmap S <Plug>BreakHere

" Don't display push enter to continue, just pop open the quicklist
function! Make()
  update
  silent !clear
  silent make
  redraw!
  cwindow
"   for i in getqflist()
"     if i['valid']
"       cwin
"       winc p
"       return
"     endif
"   endfor
endfunction

" " Call make silently
nmap <silent> <leader>m :call Make()<CR>

nnoremap <F5> :call Make()<CR>
nnoremap <F6> :GundoToggle<CR>

"Insert date in insert mode
inoremap <C-d>   <C-R>=strftime('%F')." "<CR>

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

"Unmap ex mode
noremap Q <NOP>

" vim-rsi like mappings
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

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

" Stop AnsiEsc mappings
let g:no_cecutil_maps = 1

runtime bundle/vim-pathogen/autoload/pathogen.vim
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
if !exists("g:vimrc_loaded")
    call pathogen#infect()
endif

let g:jellybeans_overrides = {
\    'background': { 'guibg': '000000' }
\}
silent! colorscheme jellybeans

nmap <leader>p <Plug>yankstack_substitute_newer_paste
nmap <leader>P <Plug>yankstack_substitute_older_paste

"Execute commands after cursor, with some reference from:
"http://stackoverflow.com/questions/26884104/
function! CutAndRunNormal()
    normal! D
    if @" =~ '^:'
        exec @"
    else
        normal @"
    endif
endfunction
function! RunNormal()
    normal! y$
    if @" =~ '^:'
        exec @"
    else
        normal @"
    endif
endfunction

nnoremap <silent> <leader>x :call CutAndRunNormal()<CR><Esc>
nnoremap <silent> <leader>gx :call RunNormal()<CR><Esc>

function! RunShell(type)
    if a:type ==# 'v'
        " Visual mode
        execute "normal! `<v`>y"
    elseif a:type ==# 'V'
        " Visual line mode
        execute "normal! `<V`>y"
    elseif a:type ==# ''
        " Visual block mode
        execute "normal! `<V`>y"
    elseif a:type ==# 'char'
        " Characterwise motion
        execute "normal! `[v`]y"
    else
        return
    endif
    " Run the raw string as a shell command
    execute ":!" . @"
endfunction

nnoremap <silent> <leader>! :set operatorfunc=RunShell<CR>g@
vnoremap <silent> <leader>! :<c-u>call RunShell(visualmode())<CR>

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

" Disable everything that inserts characters in the margins
function! Gutter()
    if &number || &relativenumber || &showbreak == "↪"
        set nonumber
        set norelativenumber
        set showbreak=
        if &signcolumn == "yes"
            setlocal signcolumn=no
        endif
    else
        set number
        set relativenumber
        set showbreak=↪
        if &signcolumn == "no"
            setlocal signcolumn=yes
        endif
    endif
    if !empty(glob("~/.vim/bundle/vim-signify"))
        SignifyToggle
    endif
endfunction
nmap <silent> gh :call Gutter()<CR>

let g:signify_vcs_list = [ 'git', 'hg' ]

" See http://vim.wikia.com/wiki/Diff_current_buffer_and_the_original_file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

if !empty(glob("~/.vim/bundle/CamelCaseMotion"))
    call camelcasemotion#CreateMotionMappings('<leader>')
endif

if !empty(glob("~/.vim/bundle/poppy.vim"))
    au! cursormoved * call PoppyInit()
endif

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#example#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#redgreen#enabled = 1
let g:airline_theme="jellybeans"
" let g:airline_left_sep = '▙'
" let g:airline_right_sep = '▟'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = '§'
let g:airline_mode_map = {
    \ '__' : '------',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'v'  : 'v',
    \ 'V'  : 'V',
    \ 'c'  : 'C',
    \ '' : 'B',
    \ 's'  : 's',
    \ 'S'  : 'S',
    \ '' : 'b',
    \ 't'  : 'T',
    \ }
" Hide filetype
" let g:airline_section_x = ""
" Hide encoding
let g:airline_section_y = ""

"Versions prior to 701.040 don't have the method Syntastic uses for
"highlighting
if v:version < 701 || v:version == 701 && !has('patch040')
    let g:syntastic_enable_highlighting = 0
endif

let g:better_whitespace_filetypes_blacklist=['help', 'qf']

let g:syntastic_check_on_open=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol='✗'
let g:syntastic_style_warning_symbol='⚠'

let g:syntastic_cpp_config_file='.syntastic_cpp_config'
let g:syntastic_python_pylint_post_args = '--msg-template="{path}:{line}:{column}:{C}: [{symbol} {msg_id}] {msg}"'

" On by default, turn it off for html
let g:syntastic_mode_map = { 'mode': 'active',
        \ 'active_filetypes': [],
        \ 'passive_filetypes': ['html'] }

" use ripgrep instead of ack
let g:ackprg = "rg --vimgrep"

let wiki_user = {}
let wiki_user.path = '~/vimwiki/'
let wiki_user.diary_rel_path = './'
let wiki_user.template_path = '~/vimwiki/templates/'
let wiki_user.template_default = 'default'
let wiki_user.template_ext = '.html'
let wiki_user.path_html = '~/vimwiki_html/'
let wiki_user.css_name = '~/vimwiki/style.css'
let wiki_user.diary_caption_level = -1
let wiki_user.nested_syntaxes = {'python': 'python', 'cxx': 'cpp', 'cc': 'c', 'rust': 'rust', 'sql': 'sql', 'javascript': 'javascript', 'perl': 'perl', 'sh': 'sh', 'bash': 'sh', 'conf': 'conf', 'ssh': 'python', 'css': 'css','yaml': 'yaml', 'md': 'markdown', 'makefile': 'make', 'messages': 'messages'}

" Shortcut to search wiki faster that :VWS
command! -nargs=1 Wgrep exec ':silent grep! -i <q-args> ' . wiki_user.path . '*.wiki' | :copen | :let @/ = <q-args> | :redraw!

let g:vimwiki_list = [wiki_user]
" let g:vimwiki_folding='expr'
let g:vimwiki_map_prefix = '<leader>g'

" Handler for precise linking
function! VimwikiWikiIncludeHandler(value)
    let url = matchstr(a:value, g:vimwiki_global_vars['rxWikiInclMatchUrl'])
    let desc = matchstr(a:value, '{{.*|\zs\%([^|}]*\)\ze}}')
    if url[0] == '.'
        let url = url[1:]
        return '<a href="'.url.'">'.desc.'</a>'
    endif
    return ''
endfunction

let g:vimrc_loaded = 1
