" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'

" OMG - insanely awesome fuzzy search and blazing fast grep
Plug 'cloudhead/neovim-fuzzy'

" Ack-grep
"Plug 'gabesoft/vim-ags'
" Faster than Ack-grep
Plug 'jremmen/vim-ripgrep'

" Tasty theme
Plug 'mhartington/oceanic-next'

Plug 'chaoren/vim-wordmotion'

" Javascript goodies
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

""" Elixir goodies

" To get the documentation for the item under your cursor, just hit K.
" Press C-] on `Guardian.Plug.VerifyHeader` for example
Plug 'slashmili/alchemist.vim'

" Autoformat .ex files
Plug 'mhinz/vim-mix-format'
let g:mix_format_on_save = 1
"let g:mix_format_silent_errors = 1
"
" autoformat elixir files
"autocmd BufWritePost *.exs,*.ex silent :!mix format %
"
"Plug 'sbdchd/neoformat'
Plug 'sheerun/vim-polyglot'

" Execute code checks, find mistakes, in the background
Plug 'neomake/neomake'

" Run Neomake when I save any buffer
augroup localneomake
  autocmd! BufWritePost * Neomake
augroup END
" Don't tell me to use smartquotes in markdown ok?
let g:neomake_markdown_enabled_makers = []
" https://www.smoothterminal.com/articles/neovim-for-elixir
let g:neomake_elixir_enabled_makers = ['mix', 'credo']

Plug 'Yggdroot/indentLine'
" custom inconsolata font file with dotted lines.
let g:indentLine_char = '┆'
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#3c464d'

" :Gblame, :Gdiff, :Gstatus and more!
Plug 'tpope/vim-fugitive'

" Comment stuff out. gcc <count of lines> or `gc` e.g. `gcap` (comment a
" paragraph)
Plug 'tpope/vim-commentary'

" Save session with `:Obsess blah` then restore it with `:source blah`
Plug 'tpope/vim-obsession'

Plug 'tpope/vim-sensible'

" Press `cs"'` inside "Hello" to change it to 'Hello'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Autocomplete with deoplete.
" https://github.com/Shougo/deoplete.nvim/issues/550
let g:python3_host_prog  = '/usr/local/Cellar/python3/3.7.0/bin/python3'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'w0rp/ale'

" Always load last!
Plug 'ryanoasis/vim-devicons'

" NERD Tree - tree explorer
" https://github.com/scrooloose/nerdtree
" http://usevim.com/2012/07/18/nerdtree/
" (loaded on first invocation of the command)
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" nerdtree-git-plugin - show git status in NERD Tree
" https://github.com/Xuyuanp/nerdtree-git-plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" Initialize plugin system
call plug#end()


set shell=zsh

set autoread " ReaLoad a file if was changed outside of Vim<Paste>

" Auto refresh NERDTree every 4s
au CursorHold * if exists("t:NerdTreeBufName") | call <SNR>15_refreshRoot() | endif

" Auto-settings
" au FocusLost * :wa " tabing away from Vim = save file
set hidden
set history=1000
set title "rewrite the teriminal title
set number " show line number

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1
set backspace=2   " Backspace deletes like most programs in insert mode

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab " don't use actual tab character (ctrl-v)
set autoindent
set smartindent   "does the right thing (mostly) in programs
" auto indent with newline
imap <C-Return> <CR><CR><C-o>k<Tab>

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

"""
" STARTUP
"""

" Auto start NERD tree when opening a directory
"autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif

" Auto start NERD tree if no files are specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif

" Let quit work as expected if after entering :q the only window left open is NERD Tree itself
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"""
" THEME
"""

" Or if you have Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

"  " Theme
syntax enable
colorscheme OceanicNext

" airline config for theme
let g:airline_theme='oceanicnext'


"""
"  KEY REMAPS
"""

" Leader key behavior and settings
let mapleader = " "


" CTRLP with fuzzy
nnoremap <C-p> :FuzzyOpen<CR>
map <C-n> :NERDTreeToggle<CR>

" Find in tree
nmap <leader>n :NERDTreeFind<CR>

" Show hide NERDTree
nmap <leader>m :NERDTreeToggle<CR>

" CTRL+s to save
nmap <c-s> :w<CR>
vmap <c-s> <Esc><c-s>gv
imap <c-s> <Esc><c-s>

"""
" BEHAVIOURS
""""

""" Leader key maps

" " Use Ripgrep
"  Usage - search and replace in all files
"   :Rg <search-term>
"   :cfdo %s/match/pattern/ge | update
"
"
noremap <leader>a :Rg<space>

" " reselect text I just pasted
nnoremap <leader>v V`]
" " edit vimrc in a vertical split
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
" " open new v split and switch to it
nnoremap <leader>w <C-w>v<C-w>l


" Ale. Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1


"""
" PRETTIER OVERRIDES
""""

" max line length that prettier will wrap on
" Prettier default: 80
let g:prettier#config#print_width = 80

" number of spaces per indentation level
" Prettier default: 2
let g:prettier#config#tab_width = 2

" use tabs over spaces
" Prettier default: false
let g:prettier#config#use_tabs = 'false'

" print semicolons
" Prettier default: true
let g:prettier#config#semi = 'false'

" single quotes over double quotes
" Prettier default: false
let g:prettier#config#single_quote = 'true'

" print spaces between brackets
" Prettier default: true
let g:prettier#config#bracket_spacing = 'true'

" put > on the last line instead of new line
" Prettier default: false
let g:prettier#config#jsx_bracket_same_line = 'false'

" avoid|always
" Prettier default: avoid
let g:prettier#config#arrow_parens = 'avoid'

" none|es5|all
" Prettier default: none
let g:prettier#config#trailing_comma = 'es5'

" flow|babylon|typescript|css|less|scss|json|graphql|markdown
" Prettier default: babylon
let g:prettier#config#parser = 'flow'

" cli-override|file-override|prefer-file
let g:prettier#config#config_precedence = 'prefer-file'

" always|never|preserve
let g:prettier#config#prose_wrap = 'preserve'


" ON SAVE
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfun

" Strip whitespace all files on save
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
" Limit strip whitespace to certain files
"autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" run neoformat on save
"augroup fmt
"  autocmd!
"  autocmd bufwritepre * undojoin | neoformat
"augroup end

"Async run prettier
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue Prettier

