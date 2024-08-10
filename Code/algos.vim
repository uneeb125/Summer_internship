let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/University/mitacs
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +28 Code/Optimizers/01_CO_Cheetah_Optimizer/CO.m
badd +13 ~/University/mitacs/Code/Optimizers/02_WGA_Wild_Geese_Algorithm/WGA.m
badd +1 ~/University/mitacs/Code/Optimizers/03_BWO_Beluga_whale/BWO.m
badd +1 ~/University/mitacs/Code/Optimizers/04_BSLO_Blood-Sucking_Leech_Optimizer(BSLO)/BSLO.m
badd +7 ~/University/mitacs/Code/Optimizers/05_GAO_MATLAB_CODE_submission/GAO.m
badd +23 ~/University/mitacs/Code/Optimizers/06_GOA_MATLABcode_Biomimetics/GOA.m
badd +5 ~/University/mitacs/Code/Optimizers/07_DCS_minikku-Differentiated-Creative-Search-1.0.0.0/DCS.m
badd +1 ~/University/mitacs/Code/Optimizers/08_MPA_code/MPA.m
badd +1 ~/University/mitacs/Code/Optimizers/09_AHA_matlab/AHA.m
badd +1 ~/University/mitacs/Code/Optimizers/10_AO_0.2/AO.m
badd +1 ~/University/mitacs/Code/Optimizers/11_WSO_White_Shark_Optimizer_(WSO)/WSO.m
badd +1 ~/University/mitacs/Code/Optimizers/12_SNS_Social_Network_Search_(SNS)/SNS.m
argglobal
%argdel
$argadd Code/Optimizers/01_CO_Cheetah_Optimizer/CO.m
edit Code/Optimizers/01_CO_Cheetah_Optimizer/CO.m
argglobal
balt ~/University/mitacs/Code/Optimizers/02_WGA_Wild_Geese_Algorithm/WGA.m
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 28 - ((20 * winheight(0) + 21) / 42)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 28
normal! 032|
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
