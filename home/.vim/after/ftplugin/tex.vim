set spell
let b:spellfile = expand('%:p:h'). '/spell.utf-8.add'
if filereadable(b:spellfile)
 let &l:spf = b:spellfile
else
 setl spf=
endif 
