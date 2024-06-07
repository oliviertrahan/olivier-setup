let mapleader = " "

" better editing experience
nnoremap J miJ`i
nnoremap H Hzz
nnoremap L Lzz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap yA mpgg0VG$y`p
nnoremap =A mpgg0VG$=`p
nnoremap Q @q
xnoremap Q :norm @q<CR>
nnoremap x "_dl
nnoremap gb <C-6>

" better editing experience
nnoremap d/ d/\c
nnoremap d? d?\c
nnoremap c/ c/\c
nnoremap c? c?\c
nnoremap y/ y/\c
nnoremap y? y?\c
nnoremap / /\c
nnoremap ? ?\c

" create new line without going into insert mode
nnoremap <leader>O Oi<ESC>"_dl
nnoremap <leader>o oi<ESC>"_dl

" better visual experience
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap x <Esc>
vnoremap A mpgg0oG$
vnoremap H Hzz
vnoremap L Lzz
vnoremap > >gv
vnoremap < <gv
vnoremap y ygv<Esc>
vnoremap Y +ygv<Esc>
vnoremap D +dgv<Esc>
vnoremap d 0d'
vnoremap p 0p'
vnoremap P +p'
vnoremap i <Esc>^v$h

" better insert experience
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>a
inoremap <C-d> <C-o>diw
inoremap <C-c> <Esc>
inoremap jj <Esc>
inoremap <Tab> <C-V><Tab>
