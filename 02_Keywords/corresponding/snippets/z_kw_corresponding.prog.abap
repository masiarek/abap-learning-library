REPORT z_kw_corresponding.

TYPES: BEGIN OF ty_source,
         id   TYPE i,
         name TYPE string,
         city TYPE string,
       END OF ty_source.

TYPES: BEGIN OF ty_target,
         id      TYPE i,
         name    TYPE string,
         country TYPE string,
       END OF ty_target.

DATA(ls_src) = VALUE ty_source( id = 1 name = `Ada` city = `London` ).

" MOVE-CORRESPONDING writes into a structure that already exists, and leaves
" every component it has nothing to say about untouched: country survives.
DATA ls_kept TYPE ty_target.
ls_kept-country = `UK`.
MOVE-CORRESPONDING ls_src TO ls_kept.

" CORRESPONDING #( ) builds a NEW value. Nothing survives, because nothing was
" there: country comes back initial. This is the difference that bites.
DATA(ls_fresh) = CORRESPONDING ty_target( ls_src ).

" BASE is how the keep-what-was-there behaviour comes back, as an expression.
DATA(ls_based) = CORRESPONDING ty_target( BASE ( VALUE ty_target( country = `UK` ) )
                                          ls_src ).

" Names that do not match are not moved -- unless MAPPING says they are.
DATA(ls_mapped) = CORRESPONDING ty_target( ls_src MAPPING country = city ).

" EXCEPT drops a component that would otherwise have been copied.
DATA(ls_except) = CORRESPONDING ty_target( ls_src EXCEPT name ).

WRITE: / 'kept   ', ls_kept-name,   ls_kept-country.
WRITE: / 'fresh  ', ls_fresh-name,  ls_fresh-country.
WRITE: / 'based  ', ls_based-name,  ls_based-country.
WRITE: / 'mapped ', ls_mapped-name, ls_mapped-country.
WRITE: / 'except ', ls_except-name, ls_except-country.
