let mapleader="\<Space>"

" set options
set nu
set relativenumber
set autoread
set showmode!
set wrap
set hlsearch! " ! means setting to false
set incsearch
set ignorecase& " & means settings to default

" better movement experience
nnoremap J miJ`i
nnoremap H <C-u>zz
nnoremap L <C-d>zz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap gb <C-6>
nnoremap ZZ :xa!<CR>

" motions related to I and A
nmap dI d^
nmap cI c^
nmap yI y^
nmap dA D
nmap cA C
nmap yA Y

" select whole file with aa "text object"
nnoremap yaa mpgg0VG$y`pzz
nnoremap =aa mpgg0VG$=`pzz
vnoremap aa gg0oG$

" line selector
vnoremap iL <Esc>^v$h
vnoremap il <Esc>^v$h

" start macro which goes to the beginning of the line
nnoremap <Space>qq qq^
nnoremap Q @q
" execute macro on all lines
vnoremap Q :norm @q<CR>

" dont change the register when deleting a single character
nnoremap x "_dl

" dont want indentation as operators, just apply it on the line
nnoremap < <<
nnoremap > >>
" for visual mode, keep the selection after indenting for further indenting
vnoremap > >gv
vnoremap < <gv

" easy common substitution logic
nnoremap <Space>ss yiw:s/\V<C-r>"//g<Left><Left>
vnoremap <Space>ss :s/\V<C-r>"//g<Left><Left>

" <Ctrl-i> is the same as <Tab> on most terminals
nnoremap <C-m> <C-i>

" better search editing experience
nmap d/ d/\c
nmap d? d?\c
nmap c/ c/\c
nmap c? c?\c
nmap y/ y/\c
nmap y? y?\c
nmap / /\c
nmap ? ?\c

" useful new motions
nnoremap ci; Bct;
nnoremap di; Bdt;
nnoremap yi; Byt;
vnoremap i; Bot;

nnoremap ci: Bct:
nnoremap di: Bdt:
nnoremap yi: Byt:
vnoremap i: Bot:

nnoremap ci/ T/ct/
nnoremap di/ T/ct/
nnoremap yi/ T/ct/
vnoremap i/ T/ot/


" create new line without going into insert mode
" using <leader> won't work for some reason
nnoremap <Space>O Oi<Esc>"_dl
nnoremap <Space>o oi<Esc>"_dl

" better visual experience
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap x <Esc>
vnoremap H <C-u>zz
vnoremap L <C-d>zz
vnoremap <C-d> <C-d>zz
vnoremap <C-u> <C-u>zz
vnoremap y ygv<Esc>
vnoremap Y "+ygv<Esc>
vnoremap D "+dgv<Esc>
vnoremap d "0d
vnoremap p "0p
vnoremap P "+p

" better insert experience
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>a
inoremap <C-a> <C-o>A
inoremap <C-d> <C-o>diw
inoremap <C-f> <C-r>"
inoremap <C-c> <Esc>
inoremap jj <Esc>
inoremap jk j<Esc>

" make quickfix enter key open at location
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

