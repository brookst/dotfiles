" base64 unimpaired maps
" place this file in ~/.vim/after/plugin/vim-unimpaired
function! B64_encode(str)
  return substitute(system('base64', a:str),'\n','','g')
endfunction

function! B64_decode(str)
  return system('base64 --decode', a:str)
endfunction

call UnimpairedMapTransform('B64_encode','[B')
call UnimpairedMapTransform('B64_decode',']B')
" vim:set sw=2 sts=2:
