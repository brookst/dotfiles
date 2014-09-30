set spell
if filereadable(expand('%:p:h'). '/spell.utf-8.add')
 let b:spellfile = expand('%:p:h'). '/spell.utf-8.add'
 let &l:spf = b:spellfile
" There must be a better way to ascend the directory path
elseif filereadable(expand('%:p:h:h'). '/spell.utf-8.add')
 let b:spellfile = expand('%:p:h:h'). '/spell.utf-8.add'
 let &l:spf = b:spellfile
" This'll do for now
elseif filereadable(expand('%:p:h:h:h'). '/spell.utf-8.add')
 let b:spellfile = expand('%:p:h:h:h'). '/spell.utf-8.add'
 let &l:spf = b:spellfile
else
 setl spf=
endif
