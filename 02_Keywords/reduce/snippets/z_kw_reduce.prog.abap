REPORT z_kw_reduce.

TYPES ty_ints TYPE STANDARD TABLE OF i WITH EMPTY KEY.

DATA(lt_n) = VALUE ty_ints( ( 3 ) ( 1 ) ( 4 ) ( 1 ) ( 5 ) ).

" INIT names the accumulator and its starting value; NEXT says how each row
" changes it; the type in front is the type of the result.
DATA(lv_sum) = REDUCE i( INIT s = 0
                         FOR lv_x IN lt_n
                         NEXT s = s + lv_x ).

" A maximum is the same shape with a different NEXT.
DATA(lv_max) = REDUCE i( INIT m = 0
                         FOR lv_y IN lt_n
                         NEXT m = COND #( WHEN lv_y > m THEN lv_y ELSE m ) ).

" WHERE filters what is folded. table_line names the whole row of a table that
" has no components to name -- and it can only be compared, not calculated with:
" WHERE ( table_line MOD 2 = 1 ) is a syntax error, not a slow filter.
DATA(lv_big) = REDUCE i( INIT c = 0
                         FOR lv_z IN lt_n WHERE ( table_line > 2 )
                         NEXT c = c + 1 ).

" The accumulator need not be a number.
DATA(lv_csv) = REDUCE string( INIT out = ``
                              FOR lv_v IN lt_n
                              NEXT out = COND #( WHEN out IS INITIAL
                                                 THEN |{ lv_v }|
                                                 ELSE |{ out },{ lv_v }| ) ).

WRITE: / 'sum ', lv_sum.
WRITE: / 'max ', lv_max.
WRITE: / 'over2', lv_big.
WRITE: / 'csv ', lv_csv.
