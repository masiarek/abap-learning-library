REPORT z_tp_types_at_a_glance.

" One variable of each elementary type, so the table on the page is backed
" by a program and not recited.
DATA lv_c   TYPE c LENGTH 4.             " text, fixed length, blank-padded
DATA lv_n   TYPE n LENGTH 4.             " digits only, fixed, zero-padded
DATA lv_d   TYPE d.                      " YYYYMMDD, eight characters
DATA lv_t   TYPE t.                      " HHMMSS, six characters
DATA lv_x   TYPE x LENGTH 2.             " raw bytes, fixed
DATA lv_i   TYPE i.                      " 32-bit integer
DATA lv_i8  TYPE int8.                   " 64-bit integer
DATA lv_p   TYPE p LENGTH 8 DECIMALS 2.  " packed decimal, exact
DATA lv_f   TYPE f.                      " binary float -- not for money
DATA lv_df  TYPE decfloat34.             " decimal float, exact, 34 digits
DATA lv_s   TYPE string.                 " text, variable length
DATA lv_xs  TYPE xstring.                " bytes, variable length

lv_c  = 'ab'.
lv_n  = 42.
lv_d  = sy-datum.
lv_t  = sy-uzeit.
lv_x  = 'FF01'.
lv_i  = -7.
lv_i8 = 9000000000.
lv_p  = '1234.56'.
lv_f  = '0.1'.
lv_df = '0.1'.
lv_s  = `ab`.
lv_xs = 'FF01'.

WRITE: / 'c    [', lv_c, ']'.
WRITE: / 'n    [', lv_n, ']'.
WRITE: / 'd     ', lv_d.
WRITE: / 't     ', lv_t.
WRITE: / 'x     ', lv_x.
WRITE: / 'i     ', lv_i.
WRITE: / 'int8  ', lv_i8.
WRITE: / 'p     ', lv_p.
WRITE: / 'f     ', lv_f.
WRITE: / 'df34  ', lv_df.
WRITE: / 's    [', lv_s, ']'.
WRITE: / 'xs    ', lv_xs.

" The same digits in c and in n are different values: n compares as a
" number, c as text -- and as text, '9' sorts after '10'.
DATA lv_text_nine TYPE c LENGTH 2 VALUE '9'.
DATA lv_text_ten  TYPE c LENGTH 2 VALUE '10'.
IF lv_text_nine > lv_text_ten.
  WRITE: / 'as text, 9 sorts after 10'.
ENDIF.

" 0.1 is exact in decfloat34 and not in f. The program prints both; the page
" says which one a finance colleague will accept.
WRITE: / 'f    0.1 * 3 =', lv_f * 3.
WRITE: / 'df34 0.1 * 3 =', lv_df * 3.

DESCRIBE FIELD lv_p LENGTH DATA(lv_bytes) IN BYTE MODE.
WRITE: / 'p LENGTH 8 occupies bytes', lv_bytes.
