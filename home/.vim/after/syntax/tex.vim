" Glossaries commands
syn region texZone start="\\[g,G]ls\(pl\)*\(long\)*{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\glsdesc{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\acrlong{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\newacronym{[^}]*}{" end="}\|%stopzone\>" contains=@NoSpell
syn region texZone start="\\newglossaryentry{" end="}\|%stopzone\>" contains=@NoSpell
