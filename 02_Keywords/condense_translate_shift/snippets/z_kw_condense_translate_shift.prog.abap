REPORT z_kw_condense_translate_shift.

" These statements change the variable IN PLACE and return nothing, which is
" why none of them can appear inside an expression.
DATA lv_text TYPE string VALUE `  Ada   Lovelace  `.

CONDENSE lv_text.                      " leading blanks gone, runs of blanks to one
WRITE: / '[', lv_text, ']'.
CONDENSE lv_text NO-GAPS.              " every blank gone
WRITE: / '[', lv_text, ']'.

DATA lv_word TYPE string VALUE `abap`.
TRANSLATE lv_word TO UPPER CASE.
WRITE: / lv_word.
TRANSLATE lv_word USING 'AXPY'.        " pairs, in order: A becomes X, P becomes Y
WRITE: / lv_word.

DATA lv_num TYPE c LENGTH 10 VALUE '42'.
SHIFT lv_num RIGHT DELETING TRAILING space.
WRITE: / '[', lv_num, ']'.
SHIFT lv_num LEFT DELETING LEADING space.
WRITE: / '[', lv_num, ']'.
SHIFT lv_num BY 1 PLACES LEFT.
WRITE: / '[', lv_num, ']'.

" The function form of each returns a value and leaves the original alone --
" the shape to prefer whenever the result feeds an expression.
DATA(lv_orig) = `  keep me  `.
DATA(lv_new)  = condense( lv_orig ).
WRITE: / '[', lv_orig, ']'.
WRITE: / '[', lv_new, ']'.
WRITE: / to_upper( shift_left( val = lv_orig sub = ` ` ) ).
