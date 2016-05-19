set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Manage these plugins
Plugin 'gmarik/Vundle.vim'

" fuzzy search files
Plugin 'wincent/command-t'
let g:CommandTMatchWindowReverse=1
let g:CommandTMinHeight=10
let g:CommandTMaxHeight=10
let g:CommandTAcceptSelectionTabMap = '<CR>'
let g:CommandTAcceptSelectionMap = '<C-CR>'
let g:CommandTCancelMap = ['<ESC>', '<C-c>']

" repeat hooks for other plugins
Plugin 'tpope/vim-repeat'

" Ruby
Plugin 'vim-ruby/vim-ruby'

" pgsql
Plugin 'exu/pgsql.vim'

" Javascript
Plugin 'pangloss/vim-javascript'

" JSX
Plugin 'mxw/vim-jsx'
let g:jsx_ext_required = 0

" Coffeescript
Plugin 'kchmck/vim-coffee-script'

" Ruby text objects
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'

" Elixir
Plugin 'elixir-lang/vim-elixir'

" Easy quoting with the surround plugin
Plugin 'tpope/vim-surround'

" Insert or delete brackets, parens, quotes in pair
Plugin 'jiangmiao/auto-pairs'

" Ag file searching
Plugin 'rking/ag.vim'
" search case sensitive if there is an uppercase letter
let g:ag_prg="ag --vimgrep --smart-case"
" highlight search term after searching
let g:ag_highlight=1
" map <leader> F to project search
map <leader>F :<c-u>Ag <C-R>=shellescape(expand(@"),1)<CR>:copen<CR>
" map <leader> ** to project search for word under cursor
nnoremap <leader>* <*>:Ag<Space><C-R><C-W><CR>

" textmate like <Tab> expansion snippets
Plugin 'msanders/snipmate.vim'

" comment stuff in/out with gc<motion>
Plugin 'tpope/vim-commentary'

" collect programming metrics
Plugin 'wakatime/vim-wakatime'

" plugin that helps to end certain structures like if ... end
Plugin 'tpope/vim-endwise'

" Rename a buffer within Vim and on the disk
Plugin 'danro/rename.vim'

" Syntax and style checking
Plugin 'scrooloose/syntastic'
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" JSX syntastic configuration
let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_javascript_jsxhint_exec = 'npm run lint'

" Change code right in the quickfix window
Plugin 'stefandtw/quickfix-reflector.vim'

" Graph vim undo tree to make it usable
Plugin 'vim-scripts/Gundo'

" Git integration, using it for git blame in a vertical split
Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on
set number
set ruler
set encoding=utf-8
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set norelativenumber
syntax on
colorscheme Tomorrow-Night

" disable netrw banner
let g:netrw_banner=0
" disable netrw history
let g:netrw_dirhistmax=0
" netrw liststyle as tree
let g:netrw_liststyle=3
" open files on right
let g:netrw_altv=1
" open previews vertically
let g:netrw_preview=1

" make backspace work as expected
set backspace=indent,eol,start

" enable clipboard integration on osx (if compiled with +clipboard)
set clipboard=unnamed

" enable matchit
runtime macros/matchit.vim

" show hard tabs and trailing spaces
set list listchars=tab:»·,trail:·

" no vertical line
set fillchars=

" allow incremental search and highlight results
set incsearch
set hlsearch
set showmatch

" No crappy vim regular expression infile searching
" see :help magic for an explanation of flags.
nnoremap / /\M
nnoremap ? ?\M

" be case insensitive until an uppercase character is typed
set smartcase

" disable code folding
set nofoldenable

" directories for backup, tmp and swp files
set backupdir=~/.vimtmp/backup
set directory=~/.vimtmp/swap

" save an undofile to be able to undo changes after closing files
set undofile
set undodir=~/.vimtmp/undo
" use many levels of undo

" I got enough memory, no need for swap files
set noswapfile

" do not show where the cursor is (very slow with ruby syntax *sigh*)
set nocursorline

" set a scroll offset above and below the cursor
set scrolloff=10

" turn off that visual and audible bell
set vb t_vb=

" limit syntax coloring to a certain length. speeds up things when working with long lines
set synmaxcol=160

" we have a good terminal connection, send more characters for redrawing
set ttyfast

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" remap close buffer to the OSX default for close window
noremap <D-w> <C-w>q

" remove search highlight when hitting escape again
nnoremap <Enter> :nohlsearch<CR>

" yank till end of line
nnoremap Y y$

" command line shortcuts
cnoremap <C-a> <Home>

" force the save of write protected files with sudo
cmap w!! w! !sudo tee > /dev/null %

" Preserves the cursor and search history around executing a command
function! Preserve(command)
  let _s=@/
  let line = line(".")
  let col = col(".")
  execute a:command
  let @/=_s
  call cursor(line, col)
endfunction

" Removes trailing whitespace on save
autocmd BufWritePre .vimrc,Gemfile,Rakefile,*.{js,jsx,rb,ru,html,erl,erb} :call Preserve("%s/\\s\\+$//e")

" Reset CommandT cache when regaining focus or writing to a file
autocmd FocusGained * :CommandTFlush
autocmd BufWritePost * :CommandTFlush

" Allow editing crontabs
" http://stackoverflow.com/questions/15395479/why-ive-got-no-crontab-entry-on-os-x-when-using-vim
autocmd FileType crontab setlocal nowritebackup

