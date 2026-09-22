REPORT z_kw_data.

" The classic form: a name, then a type. The type comes from the Dictionary
" as often as from ABAP's own built-ins.
DATA lv_counter TYPE i.
DATA lv_name    TYPE string.
DATA lv_today   TYPE d.

CONSTANTS lc_limit TYPE i VALUE 3.

lv_counter = lc_limit.
lv_name    = `Ada Lovelace`.
lv_today   = sy-datum.

WRITE: / 'counter', lv_counter,
       / 'name   ', lv_name,
       / 'today  ', lv_today.

" Inline declaration (7.40+): the variable is born where it is used, and takes
" the type of what is written into it. There is no second place to keep in step.
DATA(lv_doubled) = lv_counter * 2.
WRITE: / 'doubled', lv_doubled.

" The inferred type is not always the one you would have declared. lv_counter
" is i, so the whole expression is integer arithmetic.
DATA(lv_half) = lv_counter / 2.
WRITE: / 'half   ', lv_half.

" Ask for a decimal type and the division is a decimal division instead.
DATA(lv_precise) = CONV decfloat34( lv_counter ) / 2.
WRITE: / 'precise', lv_precise.
