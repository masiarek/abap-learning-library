REPORT z_kw_sort.

TYPES: BEGIN OF ty_row,
         region TYPE string,
         name   TYPE string,
       END OF ty_row.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_tab( ( region = `US` name = `Grace` )
                              ( region = `EU` name = `Ada` )
                              ( region = `EU` name = `Ada` )
                              ( region = `EU` name = `Katherine` ) ).

" Always name the fields. A bare SORT sorts by the table's key, which for a
" STANDARD TABLE WITH EMPTY KEY means it sorts by nothing at all.
SORT lt_rows BY region ASCENDING name DESCENDING.

LOOP AT lt_rows INTO DATA(ls_row).
  WRITE: / ls_row-region, ls_row-name.
ENDLOOP.

" DELETE ADJACENT DUPLICATES compares NEIGHBOURS. On an unsorted table it
" removes some duplicates and keeps others, quietly. Sort first, by the same
" fields you then compare.
SORT lt_rows BY region name.
DELETE ADJACENT DUPLICATES FROM lt_rows COMPARING region name.
WRITE: / 'rows left', lines( lt_rows ).

" COMPARING ALL FIELDS is the honest default when you mean "identical rows".
DELETE ADJACENT DUPLICATES FROM lt_rows COMPARING ALL FIELDS.
WRITE: / 'rows left', lines( lt_rows ).
