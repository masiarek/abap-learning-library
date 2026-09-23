REPORT z_kw_sy_fields.

" The fields nearly every program reads. The kernel sets them; assign to one
" yourself and you are lying to the next statement that reads it.
WRITE: / 'user     ', sy-uname.
WRITE: / 'client   ', sy-mandt.
WRITE: / 'language ', sy-langu.
WRITE: / 'program  ', sy-repid.
WRITE: / 'system   ', sy-sysid.
WRITE: / 'date/time', sy-datum, sy-uzeit.
WRITE: / 'batch?   ', sy-batch.

TYPES ty_ints TYPE STANDARD TABLE OF i WITH EMPTY KEY.
DATA(lt_n) = VALUE ty_ints( ( 10 ) ( 20 ) ( 30 ) ).

" sy-tabix: the row index inside LOOP AT, and after a READ TABLE.
LOOP AT lt_n INTO DATA(lv_n).
  WRITE: / 'tabix', sy-tabix, lv_n.
ENDLOOP.

" sy-index: the pass counter of DO and WHILE. A different field, and the
" one people read in a LOOP by mistake.
DO 2 TIMES.
  WRITE: / 'index', sy-index.
ENDDO.

" sy-subrc: the return code of the LAST statement that sets one. Copy it
" straight away -- almost any statement in between can overwrite it.
READ TABLE lt_n INTO lv_n INDEX 99.
DATA(lv_rc) = sy-subrc.
WRITE: / 'read past the end ->', lv_rc.

" sy-dbcnt: rows affected by the last Open SQL statement.
SELECT carrid FROM scarr INTO TABLE @DATA(lt_carriers).
WRITE: / 'rows selected', sy-dbcnt, lines( lt_carriers ).

" sy-msg*: the last message, in pieces. See the MESSAGE page.
WRITE: / 'last message type [', sy-msgty, ']'.
