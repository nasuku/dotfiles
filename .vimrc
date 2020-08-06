set ttyfast             " have goof terminal . send more chars
set autoindent          " automatically indent new line
set autoread            " automatically read feil that has been changed on disk and doesn't have changes in vim
set autowriteall        " Automatically save before commands like :next and :make
set backspace=indent,eol,start
set binary
set cinoptions=:0,(s,u0,U1,g0,t0 " some indentation options ':h cinoptions' for details
set clipboard=unnamed
set completeopt=menuone,preview
set cursorline
set encoding=utf-8
set expandtab           " expand tabs into spaces
set foldcolumn=0        " columns for folding
set foldlevel=9
set foldmethod=indent
set gdefault            " Make /g flag default when doing :s
set guioptions-=T       " disable toolbar"
set hidden              " enable multiple modified buffers
set history=1000
set hlsearch            " Highlight search match
set ignorecase          " Do case insensitive matching
set incsearch           " Incremental search
set laststatus=2        " always show the status lines
set list listchars=tab:→\ ,trail:▸,extends:>,nbsp:_
set modelines=5         " number of lines to check for vim: directives at the start/end of file
set mousehide           " Hide mouse pointer on insert mode."
set nobackup            " do not write backup files
set nocompatible
set nofoldenable        "dont fold by default "
set nolist listchars=tab:→\ ,trail:▸,extends:>,nbsp:_
set noswapfile          " do not write .swp files
set nowrap              " Do not wrap words (view)
set number              " precede each line with its line number
set numberwidth=3       " number of culumns for line numbers
set ruler               " line and column number of the cursor position
set shell=$SHELL        " use current shell for shell commands
set shiftwidth=4        " number of spaces for indent
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set smartcase           " do not ignore if search pattern has CAPS
set smartindent         " automatically indent after {
set smarttab            " backspace at the start of the line deletes a tab-worth of space
set tabstop=4           " number of spaces in a tab
set tags=tags;/         " keep looking in all parent directories till /
set textwidth=0         " Do not wrap words (insert)
set visualbell          " use visual bell instead of beeping
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif " ignore these files when completing names and in explorer
set wildmenu            " enhanced command completion
set wrap                " need to wrap line to show the whole content"
set grepprg=rg\ --vimgrep\ --smart-case
"set grepprg=ag\ --vimgrep\ --smart-case
"set grepprg=ag\ -a\ --vimgrep
set t_ut=               "  Disable Background Color Erase (BCE) so that color schemes
                        " work properly especially background color when
                        " page-up/page-down

" Allow these file extensions to be accessed via 'gf' of only the name, for
" e.g. gf on [[AnotherPage]] should go to AnotherPage.md
set suffixesadd=.md,.txt

"==== Lets
let g:is_bash = 1        " Assume Bash is my shell (:help sh.vim)
let g:surround_no_mappings=1 " Bundle 'tpope/vim-surround'
let mapleader = "\\"      " can be different from maplocalleader if needed
let maplocalleader = "\\"
let g:EasyMotion_leader_key = ',,' " Bundle 'vim-scripts/vim-easymotion'

"==== All other misc commands
syntax enable
highlight SpellErrors guibg=red guifg=black ctermbg=red ctermfg=black " highlight spell errors

"=== Conditionals
if has("mouse")
  set mouse=a
endif
if has("persistent_undo")
  silent !mkdir -vp ~/.backup/vim/undo/ > /dev/null 2>&1
  set backupdir=~/.backup/vim,.       " list of directories for the backup file
  set directory=~/.backup/vim,~/tmp,. " list of directory names for the swap file
  set undofile
  set undodir=~/.backup/vim/undo/,~/tmp,.
endif

if has("autocmd")
    " Remember last position in file
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \  exe "normal g`\""  |
    \ endif
endif

if has("user_commands")
    " Install plug if not already installed
    let PlugInstalled=0
    let plug_file=expand('~/.vim/autoload/plug.vim')
    if !filereadable(plug_file)
        echo "Installing Plug.."
        echo ""
        silent !mkdir -p ~/.vim/autoload
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        let PlugInstalled=1
    endif
endif

call plug#begin('~/.vim/plugged')
    Plug 'godlygeek/tabular'
    " easy commenting
    Plug 'scrooloose/nerdcommenter'
    " Easily go to next/prev file,buffer,error etc
    Plug 'tpope/vim-unimpaired'
    " jump using ;;
    Plug 'vim-scripts/easymotion'
    " Edit directory entries using vim
    Plug 'c0r73x/vimdir.vim'
    " directory and file explorer
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    " buffer explorer
    Plug 'corntrace/bufexplorer'
    " colorscheme
    Plug 'vim-scripts/Zenburn'
    " Diff directory entries recursively
    Plug 'vim-scripts/DirDiff.vim'
    " Align, justify and reformat
    Plug 'vim-scripts/TextFormat'
    " List of tasks in a separate bar \T
    Plug 'vim-scripts/TaskList.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf'
    Plug 'uarun/vim-protobuf'
    Plug 'fatih/vim-go'
    Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
    Plug 'junegunn/vim-easy-align'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " for :StripWhiteSpace
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'godoctor/godoctor.vim'
    " GraphQL
    Plug 'jparise/vim-graphql'
    Plug 'rking/ag.vim'
call plug#end()

function! AirlineInit()
    let g:airline_section_y = airline#section#create(['%{getcwd()}'])
    let g:airline_section_x = airline#section#create([])
endfunction
autocmd User AirlineAfterInit call AirlineInit()
let g:airline_theme='dark'

" search case sensitive if there is an uppercase letter
let g:ag_prg="ag --vimgrep --smart-case"
" highlight search term after searching
let g:ag_highlight=1

"When .vimrc is edited, reload it
autocmd! bufwritepost vim source ~/.vimrc
autocmd BufNewFile,BufRead *.py setlocal list
autocmd BufNewFile * set fileformat=unix"


autocmd FileType crontab setlocal nowritebackup

" I want cscope from my path not a hardcoded value
if has("cscope")
    set cscopeprg=cscope
    if has("cscoperelative")
        set cscoperelative      " cscope database is relative to cscope.out
    endif
    set cscopetag           " tag-search uses cscope and ctags
    set csto=0              " first cscope and then ctags
    if filereadable("cscope.out")
        cs add cscope.out
    endif

    nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

    " use quickfix window
    set cscopequickfix=s-,c-,d-,i-,t-,e-
endif

" Bundle 'godlygeek/tabular'
" New commands to align based on = or :
" Official command is Tabularize
command -range AlignFirstEquals :<line1>,<line2>Tabularize /^[^=]*\zs/
command -range AlignFirstColon  :<line1>,<line2>Tabularize /^[^:]*\zs/



" for C use // style of comments
"let NERD_c_alt_style=1
let g:NERDCustomDelimiters = {
    \ 'h': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ 'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' }
    \ }

" Bundle 'scrooloose/nerdtree'
" tree explorer
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']

" Bundle 'tpope/vim-fugitive'
" http://vimcasts.org/blog/2011/05/the-fugitive-series/
autocmd BufReadPost fugitive://* set bufhidden=delete

" Bundle 'scrooloose/syntastic'
"let g:syntastic_c_checker = "disable"
" let g:syntastic_ignore_files = [ '.c' ]
" let g:syntastic_enable_signs=1
"let s:supported_checkers = ["flake8", "pyflakes", "pylint"]
"let g:syntastic_python_checker = 'pylint'
"let g:syntastic_python_python_exec = '//tools/python/bin/python'

let vimrc_local = expand("~/.vimrc.local", ":p")
if filereadable(vimrc_local)
    execute 'source' vimrc_local
endif
unlet vimrc_local

colorscheme zenburn

function! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>

function! CurDir()
  let curdir = substitute(getcwd(), '/Users/suresh/', "~/", "g")
  return curdir
endfunction

" Enable to copy to clipboard for operations like yank, delete, change and put
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
if has('unnamedplus')
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif

" vim-go
"let g:go_fmt_command = "~/go/bin/gofumpt -s -w"
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
let g:go_metalinter_autosave = 1
"let g:go_metalinter_command = "gometalinter -Dvetshadow  --fast --vendor --vendored-linters -D vet -D errcheck -D gotype -D gocyclo -D gas -D gosec -e .pb.go "
let g:go_metalinter_command = "golangci-lint run --fix --disable testpackage --disable godot  --disable nestif --disable gomnd --print-issued-lines=false "
"let g:go_metalinter_disabled = ['vet','vetshadow']

augroup go
  autocmd!
  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
  " Open :GoDeclsDir with ctrl-g
  "autocmd FileType go nmap <C-g> :GoDeclsDir<cr>
  "autocmd FileType go imap <C-g> <esc>:<C-u>GoDeclsDir<cr>
  " :GoBuild and :GoTestCompile
  autocmd FileType go nmap ,b :<C-u>call <SID>build_go_files()<CR>
  " :GoTest
  autocmd FileType go nmap ,t  <Plug>(go-test)
  " :GoRun
  autocmd FileType go nmap ,r  <Plug>(go-run)
  " :GoDoc
  autocmd FileType go nmap ,d <Plug>(go-doc)
  " :GoCoverageToggle
  autocmd FileType go nmap ,c <Plug>(go-coverage-toggle)
  " :GoInfo
  autocmd FileType go nmap ,i <Plug>(go-info)
  " :GoMetaLinter
  autocmd FileType go nmap ,l <Plug>(go-metalinter)
  " :GoDef but opens in a vertical split
  autocmd FileType go nmap ,v <Plug>(go-def-vertical)
  " :GoDef but opens in a horizontal split
  autocmd FileType go nmap ,s <Plug>(go-def-split)
  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" build_go_files is a custom function that builds or compiles the test file.
" It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let s:tlist_def_go_settings = 'go;g:enum;s:struct;u:union;t:type;' .
                           \ 'v:variable;f:function'
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }


function! FZFExecute()
  " Remove trailing new line to make it work with tmux splits
  let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
  if !v:shell_error
    call fzf#run({'sink': 'e', 'dir': directory, 'source': 'git ls-files', 'tmux_height': '40%'})
  else
    FZF
  endif
endfunction
command! FZFExecute call FZFExecute()
command! Fzfc call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --modified'}))


"==== maps
nmap <Leader>t <Plug>TaskList
" grep for current word
nmap <Leader>f :grep "\b<cword>\b" <CR>

nmap <Leader>] :Fzfc<cr>
nmap <Leader>e :FZFExecute<cr>

" toggle spell check with F7
nmap <F7> :setlocal spell! spell?<CR>
" delete surrounding brackets - vim-surround plugin
nmap ds  <Plug>Dsurround
" change surroundings
nmap cs  <Plug>Csurround
" in Visual mode add Surround
xmap S   <Plug>VSurround

"Switch to current dir
map <leader>cd :cd %:p:h<cr>
" Edit a file in the same directory as the current buffer
map ,a :e <c-r>=expand("%:p:r")<cr>
nnoremap ,e :b#<CR> "  to switch between 2 last buffers
nmap ,q :bd!<CR>
nmap ; :BufExplorer<CR>
