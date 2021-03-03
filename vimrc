" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)


set updatetime=300
set tabstop=2
set shiftwidth=2
set expandtab
set ai
set autoread
au CursorHold,CursorHoldI * checktime
syntax enable

call plug#begin()

Plug 'skywind3000/asyncrun.vim'
Plug 'puremourning/vimspector' " Debugger
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto completion
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/indentLine' " Display vertical lines at identation levels
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'leafgarland/typescript-vim'
Plug 'jreybert/vimagit'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ntpeters/vim-better-whitespace' " Highlight trailing whitespaces
Plug 'tpope/vim-dispatch' " Async tool
Plug 'tpope/vim-fugitive' " Useful for git blame
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'pangloss/vim-javascript'
Plug 'samoshkin/vim-mergetool'
Plug 'tpope/vim-rhubarb' " Git blame in browser
Plug 'tpope/vim-sleuth' " Automatically adjusts identation level
Plug 'vim-test/vim-test'
Plug 'wakatime/vim-wakatime' " Time tracking

call plug#end()




execute pathogen#infect()
set t_Co=256

map <F1> :make<CR>
map <F2> :NERDTreeToggle %<cr>
map <F3> :AV<CR>
map <F4> :A<CR>
"Create empty line
map <Enter> o<ESC>
map <S-Enter> O<ESC>

set runtimepath+=~/.vim/bundle/jshint2.vim/

"let g:lucius_style='dark'
"let g:lucius_contrast='normal'
"let g:lucius_contrast_bg='low'
"colorscheme lucius
"let g:solarized_termcolors=256
"let g:solarized_menu=1
"let g:solarized_contrast="normal"
set background=dark
"colorscheme solarized
colorscheme PaperColor

set foldmethod=indent
set foldlevel=5

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_concepts_highlight = 1
"colorscheme apprentice
let NERDTreeIgnore = ['\.o$','\.depends$']
let NERDTreeQuitOnOpen=1
let NERDSpaceDelims=1
let g:gitgutter_async=0
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '❱'
let g:gitgutter_sign_removed = '❌'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '❰'
let g:ctrlp_custom_ignore = 'node_modules|git'
set wildignore+=*/.git/*,*/node_modules
let test#strategy = "asyncrun_background_term"

"Tab config
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <C-PageDown> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <C-PageUp> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-d>
nmap <silent> <C-t><C-n> :TestNearest<CR>
nmap <silent> <C-t><C-f> :TestFile<CR>
nmap <silent> <C-t><C-s> :TestSuite<CR>
nmap <silent> <C-t><C-l> :TestLast<CR>
nmap <silent> <C-t><C-g> :TestVisit<CR>
nmap <Leader> :GitGutterNextHunk<CR>
nmap <Leader>gn :GitGutterNextHunk<CR>
nmap <Leader>gp :GitGutterPrevHunk<CR>
nmap <Leader>ga :GitGutterStageHunk<CR>
nmap <Leader>gu :GitGutterUndoHunk<CR>
nnoremap <leader>gs :Magit<CR>
nnoremap <Leader>gb :Gblame<CR>
" Open current line in the browser
nnoremap <Leader>gB :.Gbrowse<CR>
" Open visual selection in the browser
vnoremap <Leader>gB :Gbrowse<CR>
nmap <Leader>gd :Gdiffsplit<CR>

"
" COC ---------------------------
"
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <C-]> <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>r <Plug>(coc-rename)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" YouCompleteMe ----------------------
"
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_confirm_extra_conf = 0
" let g:ycm_enable_diagnostic_highlighting = 1
" let g:ycm_warning_symbol = '##'
" let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
" let g:ycm_goto_buffer_command='new-or-existing-tab'
" nnoremap <C-]> :YcmCompleter GoTo<CR>
" nnoremap <Leader>f :YcmCompleter FixIt<CR>
" nnoremap <Leader>r :YcmCompleter RefactorRename<Space>


" ALE ---------------------------------
"
" let g:ale_fixers = ['prettier', 'eslint']
" let g:ale_fix_on_save = 1
" let g:ale_javascript_prettier_use_local_config = 1
" let g:ale_completion_enabled = 0
" let g:ale_completion_autoimport = 1
" let g:ale_sign_error = '❌'
" let g:ale_sign_warning = '⚠️'
"

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
