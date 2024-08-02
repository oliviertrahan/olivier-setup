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
nnoremap Q @q
vnoremap Q :norm @q<CR>
nnoremap x "_dl
nnoremap gb <C-6>
nmap dI d^
nmap cI c^
nmap yI y^
nmap dA D
nmap cA C
nnoremap yA mpgg0VG$y`p
nnoremap =A mpgg0VG$=`p

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

" create new line without going into insert mode
" using <leader> won't work for some reason
nnoremap <Space>O Oi<Esc>"_dl
nnoremap <Space>o oi<Esc>"_dl

" better visual experience
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap x <Esc>
vnoremap A mpgg0oG$
vnoremap H <C-u>zz
vnoremap L <C-d>zz
vnoremap <C-d> <C-d>zz
vnoremap <C-u> <C-u>zz
vnoremap > >gv
vnoremap < <gv
vnoremap y ygv<Esc>
vnoremap Y "+ygv<Esc>
vnoremap D "+dgv<Esc>
vnoremap d "0d
vnoremap p "0p
vnoremap P "+p
vnoremap iL <Esc>^v$h
vnoremap il <Esc>^v$h

" better insert experience
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>a
inoremap <C-a> <C-o>A
inoremap <C-d> <C-o>diw
inoremap <C-c> <Esc>
inoremap jj <Esc>
inoremap <Tab> <C-V><Tab>

" make quickfix enter key open at location
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
