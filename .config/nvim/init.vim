" {{{ Plugins
" vim-plug

call plug#begin()
Plug 'robertmeta/nofrils'

Plug 'tommcdo/vim-exchange'

Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'

Plug 'sheerun/vim-polyglot'

Plug 'lervag/vimtex', { 'for': 'tex' }
let g:vimtex_fold_enabled = 1
let g:vimtex_fold_manual = 1
let g:vimtex_fold_sections = ["part", "chapter", "section", "subsection",
            \ "subsubsection", "paragraph", "subparagraph"]

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
nnoremap U :UndotreeToggle<CR>

Plug 'tommcdo/vim-lion'
let g:lion_squeeze_spaces=1

if has("nvim") || has("python3")
    Plug 'dense-analysis/ale'
    let g:ale_completion_enabled = 1
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_open_list = 1
    let g:ale_set_loclist = 0
    let g:ale_set_quickfix = 1
    let g:ale_fix_on_save = 1
    let g:ale_fixers = {
                \ '*':    ['trim_whitespace', 'remove_trailing_lines'],
                \ 'c':    ['clang-format'],
                \ 'cpp':  ['clang-format'],
                \ }

endif

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

call plug#end()

call deoplete#custom#var('omni', 'input_patterns', {
	\ 'tex': g:vimtex#re#deoplete,
	\ })

" }}}

" {{{ Undo, Backups, Swap
" Persistent undo
if has("persistent_undo")
    set undodir=~/.vim/_undo
    set undofile
    set backup
    set backupdir=~/.vim/_backup/,/tmp          " Backups
    set dir=~/.vim/_swap/                       " Swap files
endif

if has("clipboard")
    set clipboard^=unnamedplus
endif
" }}}

" {{{ Netrw
let g:netrw_liststyle = 3       " Set tree style as default
let g:netrw_winsize = 25        " Set width to 25% of page
" }}}

" {{{ Folds
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax
set modelines=1
nnoremap <SPACE> za
" }}}

" {{{ General
let g:tex_flavor = 'latex'

set scrolloff=1
set sidescrolloff=5
set display+=lastline
set autoread
set autochdir
set updatetime=250
set showmode
set cursorline                  " Highlight the current line
set formatoptions=crqnj
set backspace=indent,eol,start
set path+=**

set shiftwidth=4
set shiftround

set linebreak                   " Don't wrap words by default
set wrap
set textwidth=80
set wrapmargin=0
set colorcolumn=+1

set history=1000

set fillchars=vert:│            " vertical box-drawing character

set expandtab
set autoindent
set smartindent
set copyindent
set preserveindent
set tabstop=4
set softtabstop=0
set shiftwidth=4

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.log,.aux,.bbl,.blg,.idx,.ilg,.ind,.out,.pdf

if has('syntax') && !exists("g:syntax_on")
    syntax enable
    set omnifunc=syntax
endif

set synmaxcol=500                   " Syntax highlight only beginning of line.

set title
set showcmd                         " Show (partial) command in status line.
set showmatch                       " Show matching brackets.

set infercase
set smartcase
set incsearch
set hlsearch
nnoremap <leader><space> :nohlsearch<CR>

set gdefault                            " Substitute globally on lines
set autowrite                           " Automatically save before commands like :next and :make
set hidden                              " Hide buffers when they are abandoned
set lazyredraw                          " Redraw only when needed
set wildmenu
set wildmode=full
set wildignore=*.swp,*.bak,*.pyc,*.class
set pastetoggle=<f11>
set whichwrap+=<,>,[,]
set splitbelow splitright
set visualbell t_vb=                    " Disable the bell
set nodigraph                           " Enable input of special characters by combining two characters
set noerrorbells                        " Disable error bells
set shortmess=at                        " Abbreviate and truncate messages when necessary
set matchpairs=(:),[:],{:},<:>          " Highlight matching parens
set comments=b:#,:%,fb:-,n:>,n:)
set pumheight=7                         " Completion menu

if has("mouse")
    set mouse=a
endif

set tags=./tags;,tags;
" }}}

" {{{ Search
if executable('rg')
    set grepprg=rg
else
    set grepprg=grep\ -nH\ $*
endif

nnoremap <leader>K :silent! grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" }}}

" {{{ Functions and Commands
nnoremap <leader>= gg=G<C-o>     " reindent file

function! Spelling()
    setlocal spell
    setlocal spelllang=en_us
    setlocal complete+=kspell
endfunction
" }}}

" {{{ Autocmd
if has("autocmd")
    " Load indentation rules according to detected filetype.
    filetype plugin indent on

    augroup autosave
        autocmd!
        autocmd FocusLost,WinLeave   * silent! wa
        autocmd FocusGained,BufEnter * silent! !
    augroup END

    augroup spelling
        autocmd!
        autocmd FileType gitcommit,markdown,tex,text call Spelling()
        autocmd VimEnter * exec
                    \ "if @% == '' && filereadable(@%) == 0 && line('$') == 1 && col('$') == 1
                    \ \n call Spelling()
                    \ \n endif"
    augroup END

    augroup fast_esc
        autocmd!
        autocmd InsertEnter * set timeoutlen=150
        autocmd InsertLeave * set timeoutlen=1000
    augroup END
endif
" }}}

" {{{ Key Remaps
vnoremap Q gw
nnoremap Q gqap

inoremap {<cr> {<cr>}<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap (<cr> (<cr>)<c-o>O


"Sort selection on a line
vnoremap <F2> d:execute 'normal i' . join(sort(split(getreg('"'))), ' ')<CR>
" }}}

" {{{ Spelling
" Toggle spelling with F10 key:
nnoremap <F10> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
set spellfile=~/.vim/spellfile.add

" Highlight spelling correction:
highlight SpellBad  term=reverse     ctermbg=12 gui=undercurl guisp=Red
highlight SpellCap  term=reverse     ctermbg=9  gui=undercurl guisp=Orange
highlight SpellRare term=reverse     ctermbg=13 gui=undercurl guisp=Magenta
highlight SpellLocale term=underline ctermbg=11 gui=undercurl guisp=Yellow
set sps=best,10

set dictionary+=/usr/share/dict/words
" }}}

"{{{ Theme
set background=light
colorscheme nofrils-acme

if has("vim")
    set nocompatible
    set ttyfast
endif
" }}}


" vim:foldmethod=marker
