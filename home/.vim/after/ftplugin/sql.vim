let &l:makeprg='psql -d exercises -f %'
let &l:errorformat='%Epsql:%f:%\\d%\\+:\ ERROR:\ %m,
                   \%CLINE %l:%.%#,
                   \%Z        %p^'
" E.g.
"psql:test.sql:3: ERROR:  relation "foo" does not exist
"LINE 2:     from foo
"                 ^
"Note: The third field in the first line is the file length
