REPORT z_tp_initial_values_and_null.

" ABAP has no null. Every variable has its type's INITIAL value from the
" moment it exists, and IS INITIAL is the test.
DATA lv_i TYPE i.
DATA lv_c TYPE c LENGTH 3.
DATA lv_d TYPE d.
DATA lv_s TYPE string.
DATA lr_r TYPE REF TO data.
DATA lt_t TYPE string_table.

WRITE: / 'i      initial?', xsdbool( lv_i IS INITIAL ), lv_i.
WRITE: / 'c      initial?', xsdbool( lv_c IS INITIAL ), '[', lv_c, ']'.
WRITE: / 'd      initial?', xsdbool( lv_d IS INITIAL ), lv_d.
WRITE: / 'string initial?', xsdbool( lv_s IS INITIAL ).
WRITE: / 'ref    initial?', xsdbool( lr_r IS INITIAL ), 'bound?', xsdbool( lr_r IS BOUND ).
WRITE: / 'table  initial?', xsdbool( lt_t IS INITIAL ).

" Initial is a VALUE, so it reaches the database as 0, '' or '00000000'. A
" real SQL NULL can only come from an outer join or a column added after the
" rows were, and Open SQL tests it with IS NULL -- a different question.
SELECT c~carrid, f~connid
  FROM scarr AS c
  LEFT OUTER JOIN sflight AS f ON f~carrid = c~carrid
  WHERE f~connid IS NULL
  INTO TABLE @DATA(lt_no_flights).
WRITE: / 'carriers with no flight rows', lines( lt_no_flights ).

" CLEAR returns a variable to its initial value. It does not make it null,
" because there is no null to make it.
lv_i = 5.
CLEAR lv_i.
WRITE: / 'after CLEAR', lv_i.

" The consequence for interfaces: "no value sent" and "zero sent" arrive
" identically. If the difference matters, the payload needs a flag.
