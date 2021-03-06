" =============================================================================
" Initialization
" =============================================================================
function! SetDefault(varname, default)
    if !exists(a:varname)
        let {a:varname} = a:default
        return 0
    endif
    return 1
endfunction

" Use per-host local vimrc if available
if v:version >= 703
    function! SourceLocal(...)
        if a:0
            let rcdir = fnameescape(a:0)
        elseif exists('g:rcdir')
            let rcdir = g:rcdir
        else
            let rcdir = "~/.vimrc.d"
        endif

        for rc in globpath(expand(rcdir), '*', 0, 1)
            let rc_fullpath = expand(rc)
            if filereadable(rc_fullpath)
                execute 'source ' . rc_fullpath
            endif
        endfor
        return 1
    endfunction
else
    function! SourceLocal(...)
        if a:0
            let rcdir = fnameescape(a:0)
        elseif exists('g:rcdir')
            let rcdir = g:rcdir
        else
            let rcdir = "~/.vimrc.d"
        endif

        for rc in split(globpath(expand(rcdir), '*'), '\n')
            let rc_fullpath = expand(rc)
            if filereadable(rc_fullpath)
                execute 'source ' . rc_fullpath
            endif
        endfor
        return 1
    endfunction
endif

command! -nargs=* SourceLocal call SourceLocal(<f-args>)

call SetDefault('g:rcdir', expand('~/.vimrc.d'))

augroup vimrc
    autocmd!
augroup END

" =============================================================================
" Plugins
" =============================================================================
" Install vim-plug if it isn't already installed
" From https://github.com/junegunn/vim-plug/wiki/faq
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Load plugins
silent! if plug#begin('~/.vim/plugged')

" vim-plug - https://github.com/junegunn/vim-plug
" Reload .vimrc and call :PlugInstall to install plugins

Plug 'easymotion/vim-easymotion'

" lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Adds additional syntax highlighting and fixes for Ansible's dialect of YAML
Plug 'chase/vim-ansible-yaml', {'for': ['ansible', 'yaml']}

" A collection of vimscripts for Haskell development
Plug 'dag/vim2hs', {'for': 'haskell'}

" An ack.vim alternative mimics Ctrl-Shift-F on Sublime Text 2
Plug 'dyng/ctrlsf.vim'

" A completion plugin for Haskell, using ghc-mod
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}

" Happy Haskell programming on Vim, powered by ghc-mod
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}

" A command-line fuzzy finder written in Go
Plug 'junegunn/fzf', {'do': 'yes \| ./install --no-update-rc'}
Plug 'junegunn/fzf.vim'

" Go development plugin for Vim
Plug 'fatih/vim-go', {'for': 'go'}

" one colorscheme pack to rule them all!
Plug 'flazz/vim-colorschemes'

Plug 'honza/vim-snippets'

" A Vim alignment plugin
Plug 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'EasyAlign']}

" Low-contrast Vim color scheme based on Seoul Colors
Plug 'junegunn/seoul256.vim'

" Text object for indented blocks of lines
"Plug 'kana/vim-textobj-indent'

" Vim python-mode.  PyLint, Rope, Pydoc, breakpoints from box
Plug 'klen/python-mode', {'for': 'python'}

" jinja plugins for Vim
Plug 'lepture/vim-jinja'

if v:version >= 703
    " Show a diff via Vim sign column
    Plug 'mhinz/vim-signify'

    " a vim plugin to display the indentation levels with thin vertical
    " lines
    Plug 'Yggdroot/indentLine'
else
    " A Vim plugin for visually displaying indent levels in code
    Plug 'nathanaelkane/vim-indent-guides'

    command! IndentLinesToggle  IndentGuidesToggle
    command! IndentLinesEnable  IndentGuidesEnable
    command! IndentLinesDisable IndentGuidesDisable
endif

" Vastly improved Javascript indentation and syntax support in Vim
Plug 'pangloss/vim-javascript', {'for': 'javascript'}

" A collection of vim syntax files for working in the shakespeare templating
" languages used by Yesod
Plug 'pbrisbin/vim-syntax-shakespeare'

" provides insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'Raimondi/delimitMate'

" Vim filetype and tools support for Crystal language
Plug 'rhysd/vim-crystal'

" Vim syntax highlighting for Bats (Bash Automated Test System)
Plug 'rosstimson/bats.vim'

" A tree explorer plugin for vim
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

" Syntax checking hacks for vim
Plug 'scrooloose/syntastic'

" The ultimate snippet solution for Vim
Plug 'SirVer/ultisnips'

" Interactive command execution in Vim
Plug 'Shougo/vimproc.vim', {'do': 'make'}

" True Sublime Text style multiple selections for Vim
Plug 'terryma/vim-multiple-cursors'

" Wise endings
Plug 'tpope/vim-endwise'

" Helpers for UNIX
Plug 'tpope/vim-eunuch'

" A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-markdown'

" Enable repeating supporting plugin maps with "."
" example: silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
Plug 'tpope/vim-repeat'

" Defaults everyone can agree on
Plug 'tpope/vim-sensible'

" Heuristically set buffer options
Plug 'tpope/vim-sleuth'

" surround.vim: quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" tmux basics
Plug 'tpope/vim-tbone'

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Combine with netrw to create a delicious salad dressing
Plug 'tpope/vim-vinegar'

" kickstart.vim provides syntax highligting for RedHat Linux kickstart files
Plug 'tangledhelix/vim-kickstart', {'for': 'kickstart'}

Plug 'Valloric/YouCompleteMe', {'do': './install.sh'}
autocmd! User YouCompleteMe call youcompleteme#Enable()

" Support for Perl 5 and Perl 6 in Vim
if v:version >= 704
    Plug 'vim-perl/vim-perl', {
        \ 'for': 'perl',
        \ 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
else
    Plug 'vim-perl/vim-perl', {
        \ 'for': 'perl',
        \ 'do': 'make clean fix_old_vim carp dancer highlight-all-pragmas moose test-more try-tiny' }
endif


" Ruby support
Plug 'vim-ruby/vim-ruby'

" Create aliases for Vim commands
Plug 'vim-scripts/cmdalias.vim'

" C/C++ IDE
Plug 'vim-scripts/c.vim', {'for': ['c', 'cpp']}

" jQuery IDE
Plug 'vim-scripts/jQuery', {'for': 'javascript'}

Plug 'vim-scripts/LaTeX-Box', {'for': 'plaintex'}

" Perform an interactive diff on two blocks of text
Plug 'vim-scripts/linediff.vim'

" extended % matching for HTML, LaTeX, and many other languages
Plug 'vim-scripts/matchit.zip'

" Perl IDE
"Plug 'vim-scripts/perl-support.vim', {'for': 'perl'}

" Edit files using sudo or su or any other tool
" No longer needed, since it's also in eunuch.vim
"Plug 'vim-scripts/SudoEdit.vim'

" Script to save the current file and convert it to PDF using txt2pdf
Plug 'vim-scripts/txt2pdf.vim'

" A completion function for unicode glyphs
Plug 'vim-scripts/unicode.vim'

" What it says on the tin
Plug 'vimwiki/vimwiki'

" Vim filetype detection by the she-bang line at file
Plug 'vitalk/vim-shebang'

" Miscellaneous auto-load Vim scripts
Plug 'xolox/vim-misc'

" Easy note taking in Vim
Plug 'xolox/vim-notes'

" End vim-plug block
call plug#end()
endif "/silent

" For multi-byte character support (CJK support, for example):
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1
"
" For UTF-8 support
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    "setglobal bomb
    set fileencodings=ucs-bom,utf-8,latin1
endif

" Meant to deal with errors related to Xterm's key configuration
set t_kb= t_kD=[3~

" =============================================================================
" General settings
" =============================================================================

" Meant to deal with errors related to strong Vi compatibility
" TODO Unnecessary with tpope/vim-sensible?
"set nocompatible

" Allows using the same window for multiple files, and switching from and
" unsaved buffer without having to save it first. Also allows keeping an 'undo'
" history for multiple files when reusing the same window in this way.
set hidden

" =============================================================================
" Indentation settings
" =============================================================================

" Copy indent from current line when starting a new line (typing <CR> in Insert
" mode or when using the "o" or "O" command).
set autoindent

" Number of spaces to use for each step of (auto)indent.
set shiftwidth=4

" Number of spaces that a <Tab> in the file counts for.
set tabstop=4

" Use the appropriate number of spaces to insert a <Tab>. Spaces are used in
" indents with the '>' and '<' commands and when 'autoindent' is on. To insert
" a real tab when 'expandtab' is on, use CTRL-V <Tab>.
set expandtab

" When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'.
" 'tabstop' is used in other places. A <BS> will delete a 'shiftwidth' worth of
" space at the start of the line.
set smarttab

" =============================================================================
" Splits
" =============================================================================

" New vsplit starts below
set splitbelow

" New split starts below
set splitright

" =============================================================================
" Search settings
" =============================================================================

" While typing a search command, show immediately where the so far typed
" pattern matches.
set incsearch

" Highlight search matches
set hlsearch

" Ignore case in search patterns.
set ignorecase

" Override the 'ignorecase' option if the search pattern contains upper case
" characters.
set smartcase

" Maximum width of text that is being inserted. A longer line will be broken
" after white space to get this width.
set textwidth=79

" Colorize the column just after 'textwidth'
if v:version >= 703
    set colorcolumn=+1
else
    if &textwidth > 0
        execute 'set colorcolumn=' . &textwidth + 1
    else
        set colorcolumn=80
    endif
endif

" =============================================================================
" Visual settings
" =============================================================================

" Don't allow syntax plugins to conceal text
if v:version >= 703
    set conceallevel=0
    autocmd FileType * set conceallevel=0
end

" Show the current line
"set cursorline

" Show partial commands in the last line of the screen.
set showcmd

" Show line numbers.
set number

" Set the number of characters the line numbers column displays
set nuw=4

" When a bracket is inserted, briefly jump to the matching one. The jump is
" only done if the match can be seen on the screen. The time to show the match
" can be set with 'matchtime'.
set showmatch

" Always the tab bar
"set showtabline=2

" Show the line and column number of the cursor position, separated by a comma.
set ruler

" Attempt to load preferred colorscheme.  Since it might not be installed,
" default to a colorscheme bundled with Vim
try
    colorscheme solarized
catch
    colorscheme elflord
endtry

" When set to "dark", Vim will try to use colors that look good on a dark
" background. When set to "light", Vim will try to use colors that look good on
" a light background. Any other value is illegal.
set background=dark

" Always show status line, even if there's only one window
set laststatus=2

" Use visual bell instead of beeping when error occurs
set visualbell

" Set the command height window to 2 lines
set cmdheight=2

" Limit all lines to 79 characters
set tw=79

" Wraps text as close as possible to 79 characters without splitting words
set formatoptions+=t

" Don't automatically fold
set foldmethod=manual

" Stop it with the automatic folding
set foldlevelstart=20

" Don't show the current mode because airline.vim does this already
"set noshowmode

" This is a sequence of letters which describes how automatic formatting is to
" be done.
"
" letter    meaning when present in 'formatoptions'
" ------    ---------------------------------------
" c         Auto-wrap comments using textwidth, inserting the current comment
"           leader automatically.
" q         Allow formatting of comments with "gq".
" r         Automatically insert the current comment leader after hitting
"           <Enter> in Insert mode.
" t         Auto-wrap text using textwidth (does not apply to comments)
set formatoptions=c,q,r,t

" =============================================================================
" Input settings
" =============================================================================

" Enable the use of the mouse.
set mouse=a

" Hide cursor while typing
set mousehide

" Use F11 to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" Stop certain movements from always going to the start of the line.
set nostartofline

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save
set confirm

" Quickly time out on keycodes; never time out on mappings.
set notimeout ttimeout ttimeoutlen=200

" =============================================================================
" Syntax- and filetype-related settings
" =============================================================================

" XXX Not needed with vim-plug; see:
" https://github.com/junegunn/vim-plug/wiki/faq
""Attempt to determine the type of file based on its name and possibly its
""contents.  Use this to allow intelligent auto-indenting for each filetype, and
""for plugins that are filetype-specific.
"filetype plugin indent on
"
"" Enable syntax highlighting
"syntax on

" =============================================================================
" Wildmenu
" =============================================================================

" Better command-line completion
set wildmenu
set wildmode=list:longest,full

" =============================================================================
" Miscellaneous
" =============================================================================
"
" Restore cursor position
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

augroup vimrc
    " Change working directory to directory of current file
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    " Remove any trailing whitespace that is in the file
    autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

    " Automatically reload vimrc files upon BufWritePost to any of the matching
    " files
    autocmd BufWritePost .vimrc*,_vimrc*,vimrc*,vimrc*,.gvimrc*,_gvimrc*,gvimrc* SourceAll
augroup END

" =============================================================================
" Command-related settings
" =============================================================================
" Set options for the :grep command
set grepprg=grep\ -nH\ $*

" Maybe fixes BundleSearch errors?
set shell=/bin/bash

" =============================================================================
" Filetype mappings and related settings
" =============================================================================
function! SetRubyOptions()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal expandtab
endfunction

augroup vimrc
    " Automatically detect filetype upon :w
    autocmd BufRead,BufWrite,BufWritePost * if !exists("&ft") | :filetype detect | endif

    " Vim sets *.md files to Modula2 syntax
    autocmd BufRead,BufWrite,BufWritePost *.md set filetype=markdown

    " Set Rexfiles to use Perl syntax
    autocmd BufRead,BufWrite,BufWritePost,BufNewFile Rexfile set filetype=perl

    " Set Vimperator configuration file to use Vim syntax
    autocmd BufRead,BufNewFile *.vimperatorrc set filetype=vim

    " Set files in g:rcdir to use Vim syntax
    autocmd BufRead,BufNewFile * if bufname("%") =~ "^" . expand(g:rcdir) | set filetype=vim | endif

    " Set .simplecov files to use Ruby syntax
    autocmd BufRead,BufWrite,BufWritePost,BufNewFile .simplecov set filetype=ruby

    autocmd FileType ruby,eruby call SetRubyOptions()
augroup END

" =============================================================================
" Key mappings
" =============================================================================
let g:mapleader=','

" Map Y to work like D and C, i.e. to yank until EOL, rather than to act as yy,
" which is the default.
map Y y$

" Tab handling mappings
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tt :tabedit<Space>
nnoremap tn :tabnext<Space>
nnoremap tm :tabm<Space>
nnoremap td :tabclose<CR>

" Buffering handling mappings
nnoremap H :bfirst<CR>
nnoremap J :bnext<CR>
nnoremap K :bprev<CR>
nnoremap L :blast<CR>

" Enter normal mode
inoremap jjj <Esc>
" Causes trouble with mapping of J to :tabnext
"nnoremap JJJJ <Nop>

" Enter and exit 'hex mode' (streaming buffer through xxd)
noremap <F7> :%!xxd <CR>
noremap <F8> :%!xxd -r <CR>

" Map Y to work like D and C, i.e. to yank until EOL,
" rather than to act as yy, which is the default.
map Y y$

" Map <C-L> (redraw screen) to also turn off
" search highlighting until the next search.
nnoremap <C-L> :nohl<CR><C-L>

" Undo the mapping of <C-a>, since that's what I use for my tmux prefix and
" it's causing mischief with numbers
noremap <A-a> <C-a>
noremap <A-x> <C-x>
unmap <C-a>
unmap <C-x>

" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" =============================================================================
" General-Purpose Functions
" =============================================================================
function! s:ETW(what, ...)
  for f1 in a:000
    let files = glob(fnamemodify(f1, ":p"))
    if files == ''
      execute a:what . ' ' . fnameescape(f1)
    else
      for f2 in split(files, "\n")
        execute a:what . ' ' . fnameescape(f2)
      endfor
    endif
  endfor
endfunction

function! s:TabPosition(posi, ...)
    let file = fnameescape(a:1)
    if file == '0'
        execute "tabnew"
    else
        execute "tabnew " . file
    endif
    execute a:posi . "tabmove"
endfunction

" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction

function! CommandCabbrev(abbreviation, expansion)
  execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction

" Copied from spf13: https://github.com/spf13/spf13-vim/blob/3.0/.vimrc
function! InitializeDirectories()
  let parent = $HOME
  let prefix = 'vim'
  let dir_list = {
              \ 'backup': 'backupdir',
              \ 'views': 'viewdir',
              \ 'swap': 'directory' }

  if has('persistent_undo')
    let dir_list['undo'] = 'undodir'
  endif

  " To specify a different directory in which to place the vimbackup,
  " vimviews, vimundo, and vimswap files/directories, add the following to
  " your .vimrc.before.local file:
  "   let g:spf13_consolidated_directory = <full path to desired directory>
  "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
  if exists('g:spf13_consolidated_directory')
    let common_dir = g:spf13_consolidated_directory . prefix
  else
    let common_dir = parent . '/.' . prefix
  endif

  for [dirname, settingname] in items(dir_list)
    let directory = common_dir . dirname . '/'
    if exists("*mkdir")
      if !isdirectory(directory)
        call mkdir(directory)
      endif
    endif
    if !isdirectory(directory)
      echo "Warning: Unable to create backup directory: " . directory
      echo "Try: mkdir -p " . directory
    else
      let directory = substitute(directory, " ", "\\\\ ", "g")
      exec "set " . settingname . "=" . directory
    endif
endfor
endfunction

" =============================================================================
" Commands
" =============================================================================
" Syntax: [:Etabs | :Ewindows | :Evwindows] file1 [, file2, ... , fileN]
" Opens a list of files in different tabs/windows/vertical windows
command! -complete=file -nargs=+ Etabs call s:ETW('tabnew', <f-args>)
command! -complete=file -nargs=+ Ewindows call s:ETW('new', <f-args>)
command! -complete=file -nargs=+ Evwindows call s:ETW('vnew', <f-args>)

command! -nargs=+ TabPosition call s:TabPosition(<f-args>)
command! -nargs=? Tabfirst call s:TabPosition(0, <f-args>)

command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

command! -nargs=+ CommandCabbrev call CommandCabbrev(<f-args>)

command! -range=% -nargs=* PerlTidy if &filetype ==? 'perl' | <line1>,<line2> !perltidy -q -nst -b <args> <NL>| endif

" Source all vimrc files
command! SourceAll if filereadable($MYVIMRC) | source $MYVIMRC | endif | if has('gui_running') && filereadable($MYGVIMRC) |  source $MYGVIMRC | endif

" =============================================================================
" Abbreviations
" =============================================================================
" Abbreviate CommandCabbrev to a lowercase abbreviation
CommandCabbrev ccab CommandCabbrev
CommandCabbrev sw SudoWrite
CommandCabbrev sr SudoRead
CommandCabbrev src SourceAll
CommandCabbrev chk SyntasticCheck

" =============================================================================
" Plugin-specific settings
" =============================================================================
" Configure where vimwiki locates wikis and generated HTML
let g:vimwiki_list = [{
            \    'path':         '~/Dropbox/Wiki/vimwiki',
            \    'path_html':    '~/Dropbox/Wiki/vimwiki_html'}]

let g:vimwiki_conceallevel = 0

" vim-airline
" List open buffers in top status bar
let g:airline#extensions#tabline#enabled = 1

" Pretty
let g:airline_theme = 'solarized'

" Don't effing redefine my bindings, mmkay?
let g:go_doc_keywordprg_enabled = 0

" Outdent `private', `protected'.
let g:ruby_indent_access_modifier_style = 'outdent'

" haskellmode-vim
let g:haddock_browser = 'firefox'

" Try to stop autoclose from closing  comment characters in Vim files
let g:autoclose_vim_commentmode = 1

" Set file extensions that use C syntax highlighting


" Remap perl MapLeader
"let g:Perl_MapLeader = ';'
let perl_include_pod = 1
let perl_extended_vars = 1

" Deals with temporary hang when saving python files
let g:pymode_rope_lookup_project = 0

" Set docs off
let g:pymode_doc = 0
" Don't let python mode override my 'K' binding
let g:pymode_doc_bind = '<leader>K'

" vim-indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" =============================================================================
" Backups and swap files
" =============================================================================
set backup
if has('persistent_undo')
  set undofile
  set undolevels=1000
  set undoreload=10000
endif

call InitializeDirectories()

" =============================================================================
" Syntastic settings
" =============================================================================
" Options that apply to all filetypes
let g:syntastic_check_on_open = 1

" Aggregate errors/warnings from all enabled checkers
let g:syntastic_aggregate_errors = 1

" perlcritic is very slow!
"let g:syntastic_perl_checkers = ['perl', 'perlcritic']
let g:syntastic_perl_checkers = ['perl']

" Could be dangerous to use this when checking third-party files...
let g:syntastic_enable_perl_checker = 1

" Disable syntax checks for *.bats files, since shellcheck doesn't play nice
" with Bats' augmented Bash syntax
let g:syntastic_ignore_files = ['\m\.bats$']


" =============================================================================
" perlcritic.vim settings
" =============================================================================
" perlcritic.vim has a slight but important bug/flaw: it doesn't pass any
" '-12345'/'--brutal'/etc. flags to the perlcritic executable, so only
" registers policy violations of level 5, perlcritic's default severity level.
" We fix this here by manually setting the '--brutal' flag, which catches all
" severity levels.
let g:syntastic_perl_perlcritic_args = '--brutal --exclude=HardTabs'

" All perlcritic messages above 3 are highlighted as errors, the rest are shown
" as warnings
let g:syntastic_perl_perlcritic_thres = 3

" =============================================================================
" vim-ansible-yaml settings
" =============================================================================
let g:ansible_use_default_indentation = 1
"let g:ansible_shiftwidth = 8
"let g:ansible_tabstop = 8
"let g:ansible_expandtab = 0

" =============================================================================
" Sourcing further vim configurations
" =============================================================================
augroup vimrc
	autocmd VimEnter,BufEnter,BufNewFile call SourceLocal()
augroup END

call SourceLocal()
