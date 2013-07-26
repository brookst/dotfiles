let b:spellfile = expand('%:p:h'). '/spell.utf-8.add'
echom "In spelling script! >: " . b:spellfile
if filereadable(b:spellfile)
 echom "Local spellfile found!"
 let &l:spf = b:spellfile
else
 echom "No local spellfile found!"
 setl spf=
endif 
