" Glossaries commands
syn region texZone start="\\gls\(pl\)*\(long\)*{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\glsdesc{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\newacronym{[^}]*}{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\newglossaryentry{" end="}\|%stopzone\>" contains=@NoSpell
