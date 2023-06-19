" Glossaries commands
syn region texZone start="\\[g,G]ls[^{]*{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\[a,A]cr\(short\|long\|full\)\(pl\)\?{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\[g,G]lsdesc{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone matchgroup=texStatement start="\\[c,C]ref{" end="}\|%stopzone\>" contains=@texRefGroup
syn region texZone start="\\newacronym\(\[[^]]*\]\)\?{[^}]*}{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\newglossaryentry{" end="}\|%stopzone\>" contains=@NoSpell

syn cluster tikzZoneGroup contains=texComment,texDelimiter,texLength,texMathDelim,texMathMatcher,texMathSymbol,texMathText,texRefZone,texSpecialChar,texStatement,texTypeSize,texTypeStyle
syn region tikzPicture start="\\begin\s*{\s*tikzpicture\s*}" end="\\end\s*{\s*tikzpicture\s*}" keepend contains=@tikzZoneGroup

syn region texBeginEndName matchgroup=Delimiter start="{" end="}" contained nextgroup=texBeginEndModifier contains=texComment,@NoSpell

if exists('*TexNewMathZone')
    call TexNewMathZone("E","align",1)
endif

set iskeyword+=:
