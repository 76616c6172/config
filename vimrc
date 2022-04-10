" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
"
" err
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.
"
" Enable true color 
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
 
" runtime! debian.vim
" pure vi ignoring other configurations
let skip_defaults_vim=1
set nocompatible

"automatically indent new lines
set autoindent

" automatically write files when multile files open
" set autowrite

" set numbers on
"set number
"
" turn numbers off
"set nonumber
"
"disable relative line numbers
"set norelativenumber

" REMINDER : F1 toggles numbers
" set both line nums and relative nums
"set number
"set relativenumber


"
"turn col and row position on in the bottom right
"set ruler

" show command and insert mode
"set noshowmode
set showmode

" spaces and tabs etc
set tabstop=2
set shiftwidth=2
set smartindent
set smarttab

if v:version >= 800
    " stop vim from silently fucking with files that it shouldn't
    set nofixendofline
    
    " better ascii frndly listchars
    set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>

    " i fucking hate automatic folding
    set foldmethod=manual
endif

" mark trailing spaces as errors
match ErrorMsg '\s\+$'

" replace tabs with spaces automatically
set expandtab

"...max text width, twice the old 80 standard, we have big screens yo.
set textwidth =160


"more risky but cleaner
set nobackup
set noswapfile
set nowritebackup

set icon

"highlight search hits, \+<cr> to clear
set hlsearch
set incsearch
set linebreak
map <silent> <leader><cr> :noh<cr>:redraw!<cr>

" avoid most of the Hit enter.. messages
set shortmess=aoOtI

" prevents truncated yanks, deletes, etc.. VERY IMPORTANT
set viminfo='20,<1000,s1000

" not a fan of bracket matching of folding
let g:loaded_matchparen=1
set noshowmatch

" Needs to be set before the plugin is called to not throw errors
" POLYGLOT: don't do syntax highlighting on markdown
let g:polyglot_disabled = ['markdown']

" Just the defaults, these are changed per filetype by plugins.
set formatoptions-=t   " don't auto-wrap text using text width
set formatoptions+=c   " autowrap comments using textwidth with leader
set formatoptions-=r   " don't auto-insert comment leader on enter in insert
set formatoptions-=o   " don't auto-insert comment leader on o/O in normal
set formatoptions+=q   " allow formatting of comments with gq
set formatoptions-=w   " don't use trailing whitespace for paragraphs
set formatoptions-=a   " disable auto-formatting of paragraph changes
set formatoptions-=n   " don't recognized numbered lists
set formatoptions+=j   " delete comment prefix when joining
set formatoptions-=2   " don't use the indent of second paragraph line
set formatoptions-=v   " don't use broken 'vi-compatible auto-wrapping'
set formatoptions-=b   " don't use broken 'vi-compatible auto-wrapping'
set formatoptions+=l   " long lines not broken in insert mode
set formatoptions+=m   " multi-byte character line break support
set formatoptions+=M   " don't add space before or after multi-byte char
set formatoptions-=B   " don't add space between two multi-byte chars in join 
set formatoptions+=1   " don't break a line after a one-letter word

" requires PLATFORM env variable set (in ~/.bashrc)
if $PLATFORM == 'mac'
"   " required for mac delete to work
  set backspace=indent,eol,start
endif

"stop complaints about switching buffer with changes
set hidden

"command history
set history=100

"here because plugins need it
syntax enable

"allow sensing the filetype
filetype plugin on

"faster scrolling
set ttyfast

" Install vim-plug if not already installed
" (Yes I know about Vim 8 Plugins. They suck.)
if v:version >= 800 && executable('curl') && empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" only load plugins if Plug detected
if filereadable(expand("~/.vim/autoload/plug.vim"))

  " load all the plugins
  call plug#begin('~/.vimplugins')
  Plug 'sheerun/vim-polyglot'
  Plug 'ntk148v/vim-horizon'
  "Plug 'sainnhe/sonokai'
  "Plug 'joshdick/onedark.vim'
  "Plug 'rakr/vim-one'
  "Plug 'preservim/nerdtree'
  Plug 'z0mbix/vim-shfmt'
  Plug 'vim-pandoc/vim-pandoc'
  Plug 'rwxrob/vim-pandoc-syntax-simple'
  Plug 'cespare/vim-toml'
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  Plug 'PProvost/vim-ps1'
  "Plug 'roxma/vim-tmux-clipboard'
  "Plug 'pangloss/vim-javascript'
  "Plug 'tpope/vim-fugitive'
  " Plug 'morhetz/gruvbox'
  "Plug 'pangloss/vim-javascript'
  call plug#end()

  hi Normal ctermbg=NONE " for transparent background
  hi SpellBad ctermbg=red " for transparent background
  hi SpellRare ctermbg=red
  hi Special ctermfg=cyan
  au FileType pandoc hi pandocAtxHeader ctermfg=yellow cterm=bold
  au FileType pandoc hi pandocAtxHeaderMark ctermfg=yellow cterm=bold
  au FileType pandoc hi pandocAtxStart ctermfg=yellow cterm=bold
  set noruler
  set laststatus=2
  set statusline=
  set statusline+=%*\ %<%.60F%*                      " path, trunc to 80 length
  set statusline+=\ [%{strlen(&ft)?&ft:'none'}]      " filetype
  set statusline+=%*\ %l:%c%*                        " current line and column
  set statusline+=%*\ %p%%%*                         " percentage
  set cmdheight=1



"shell
  let g:shfmt_fmt_on_save = 1

  " Even though the POSIX shell standard and clean here-documents
  " require use of tabs, the amount of YAML (which forbids tabs) and
  " shell these days really mandates this. Otherwise, people will be
  " cutting and pasting in their shitty graphic editors and whine about
  " why they have tabs with their spaces in their YAML files. And most
  " Vim users don't even know what the fuck `set list` even does.
  let g:shfmt_extra_args = '-i 2'

  " pandoc
  let g:pandoc#formatting#mode = 'h' " A'
  let g:pandoc#formatting#textwidth = 72
  " golang
  let g:go_fmt_fail_silently = 0
  let g:go_fmt_command = 'goimports'
  let g:go_fmt_autosave = 1
  let g:go_gopls_enabled = 1
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_variable_declarations = 1
  let g:go_highlight_variable_assignments = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_diagnostic_errors = 1
  let g:go_highlight_diagnostic_warnings = 1
  let g:go_auto_type_info = 1
  let g:go_auto_sameids = 0
  "let g:go_metalinter_command='golangci-lint'
  "let g:go_metalinter_command='golint'
  "let g:go_metalinter_autosave=1
  set updatetime=100
  "let g:go_gopls_analyses = { 'composites' : v:false }kkkkkkkkkkkkkket showmatch " Show matching brackets.
  au FileType go nmap <leader>t :GoTest!<CR>
  au FileType go nmap <leader>v :GoVet!<CR>
  au FileType go nmap <leader>b :GoBuild!<CR>
  au FileType go nmap <leader>c :GoCoverageToggle<CR>  au FileType go nmap <leader>i :GoInfo<CR>
  au FileType go nmap <leader>l :GoMetaLinter!<CR>

else
  autocmd vimleavepre *.go !gofmt -w % " backup if fatih fails
endif



autocmd vimleavepre *.md !perl -p -i -e 's,\[([^\]]+)\]\(\),[\1](https://duck.com/lite?kd=-1&kp=-1&q=\1),g' %   

" fill in anything beginning with @ with a link to twitch to it
"autocmd vimleavepre *.md !perl -p -i -e 's, @(\w+), [\\@\1](https://twitch.tv/\1),g' %

" if you are gonna visual, might as well...
vmap < <gv
vmap > >gv
" make Y consitent with D and C (yank til end)
map Y y$

" better command-line completionset wildmenu

" disable search highlighting with <C-L> when refreshing screen
" nnoremap <C-L> :nohl<CR><C-L>

" enable omni-completion
set omnifunc=syntaxcomplete#Complete

" force some file names to be specific file type
au bufnewfile,bufRead *.bash* set ft=sh
au bufnewfile,bufRead *.pegn set ft=config
au bufnewfile,bufRead *.profile set filetype=sh
au bufnewfile,bufRead *.crontab set filetype=crontab
au bufnewfile,bufRead *ssh/config set filetype=sshconfig
au bufnewfile,bufRead .dockerignore set filetype=gitignore
au bufnewfile,bufRead *gitconfig set filetype=gitconfig
au bufnewfile,bufRead /tmp/psql.edit.* set syntax=sql
au bufnewfile,bufRead doc.go set spell


" displays all the syntax rules for current position, useful
" when writing vimscript syntax plugins
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc  

" start at last place you were editing
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"au BufWritePost ~/.vimrc so ~/.vimrc

" functions keys KEYBINDINGS
map <F1> :set number!<CR> :set relativenumber!<CR>
nmap <F2> :call <SID>SynStack()<CR>
set pastetoggle=<F3>
map <F4> :set list!<CR>
map <F5> :set cursorline!<CR>
map <F7> :set spell!<CR>
map <F12> :set fdm=indent<CR>

nmap <leader>2 :set paste<CR>i

" disable arrow keys (vi muscle memory)
"noremap <up> :echoerr "Umm, use k instead"<CR>
"noremap <down> :echoerr "Umm, use j instead"<CR>
"noremap <left> :echoerr "Umm, use h instead"<CR>
" inoremap <right> :echoerr "Umm, use l instead"<CR>
" inoremap <up> <NOP>
" inoremap <down> <NOP>
" inoremap <left> <NOP>
" inoremap <right> <NOP>
"
" Clear search highlighting by pressing enter
nnoremap <esc> :noh<return><esc>

" Better page down and page up
noremap <C-n> <C-d>
noremap <C-p> <C-b>

" Keep search centered when searching with /
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

" read personal/private vim configuration (keep last to override)
"set rtp^=~/.vimpersonal
"set rtp^=~/.vimprivate
"set rtp^=~/.vimwork

hi StatusLineNC term=bold cterm=bold gui=bold
hi StatusLine term=bold cterm=bold gui=bold

" EEEEEEEEND OF ROBS STUFF ############################

set ignorecase " Do case insensitive matching
set incsearch  " Incremental search


" Source a global configuration file if available
"if filereadable("/etc/vim/vimrc.local")
"  source /etc/vim/vimrc.local
"endif
 
"valar
"syntax on "wtf should be syntax enable
set background=dark
set scrolloff=8
set noerrorbells
set shiftwidth=2
set expandtab
"set ai
set hlsearch
set noswapfile
set numberwidth=1
"set nohlsearch  " no search hightlighting
highlight Comment ctermfg=green
set ignorecase
"set hlsearch
set incsearch
" No annoying sound on errorm
set noerrorbells
set novisualbell

set t_vb=
set tm=500
set clipboard^=unnamedplus

" IMPORTANT
if has('termguicolors')
  set termguicolors
 endif

"set nocompatible

" GO highlighting
let g:go_highlight_functions					  = 1
let g:go_highlight_function_calls			  = 1
let g:go_highlight_methods						  = 1
let g:go_highlight_structs						  = 1
let g:go_highlight_operators					  = 1
let g:go_highlight_build_constraints	  = 1
let g:go_fmt_autosave									  = 1
let g:go_highlight_function_parameters  = 1

" Python Highlighting
let g:python_highlight_builtins										= 1
let g:python_highlight_builtin_objs								= 1
let g:python_highlight_builtin_types							= 1
let g:python_highlight_builtin_funcs							= 1
let g:python_highlight_builtin_funcs_kwarg				= 1
let g:python_highlight_exceptions									= 1
let g:python_highlight_string_formatting					= 1
let g:python_highlight_string_format							= 1
let g:python_highlight_string_templates						= 1
let g:python_highlight_indent_errors							= 1
let g:python_highlight_space_errors								= 1
let g:python_highlight_doctests										= 1
let g:python_highlight_func_calls									= 1
let g:python_highlight_class_vars									= 1
let g:python_highlight_operators									= 1
let g:python_highlight_all												= 1
let g:python_highlight_file_headers_as_comments		= 1
let g:python_slow_sync														= 1

" VIM PLUG SETTINGS
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" THEME AND PLUGIN CONFIGURATION
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" THEME AND PLUGIN CONFIGURATION
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"
"
" onedark.vim override: Don't set a background color when running in a terminal;
" just use the terminal's background color
" `gui` is the hex color code used in GUI mode/nvim true-color mode
" `cterm` is the color code used in 256-color mode
" `cterm16` is the color code used in 16-color mode
"
"if (has("autocmd") && !has("gui_running"))
"  augroup colorset
"    autocmd!
"    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
"    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
"  augroup END
"endif

"Sonokai color config (the configuration options should be placed before `colorscheme sonokai` )
" let g:sonokai_style = 'andromeda'
" let g:sonokai_enable_italic = 0
" let g:sonokai_disable_italic_comment = 1
" let g:sonokai_transparent_background = 1
" colorscheme sonokai

colorscheme horizon
" colorscheme onedark
" colorscheme one


" AIRLINE + GIT + NERDTREE PLUGIN SETTINGS
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
" let g:airline_theme = 'sonokai'
"let g:NERDTreeGitStatusUseNerdFonts = 1
"let g:NERDTreeGitStatusWithFlags = 1

" open NERDTree automatically
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" close nerdtree when exiting the last files
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
" CTRL + E toggles NERDTree explorer
"map <C-e> :NERDTreeToggle<CR>
" This below is for gitstatus nertree plugin, which I have currently disabled.
"let g:NERDTreeGitStatusIndicatorMapCustom = {
"\ 'modified' :'✹',
"\ 'staged' :'✚',
"\ 'untracked' :'✭',
"\ 'renamed' :'➜',
"\ 'unmerged' :'═',
"\ 'deleted' :'✖',
"\ 'dirty' :'✗',
"\ 'ignored' :'☒',
"\ 'clean' :'✔︎',
"\ 'unknown' :'?',
"\ }
