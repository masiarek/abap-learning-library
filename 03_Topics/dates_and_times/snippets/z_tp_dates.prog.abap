REPORT z_tp_dates.

" TYPE d is eight characters, YYYYMMDD, and arithmetic on it counts DAYS.
DATA(lv_today) = sy-datum.
DATA(lv_in_30) = CONV d( lv_today + 30 ).
DATA(lv_days)  = lv_in_30 - lv_today.

WRITE: / 'today     ', lv_today.
WRITE: / 'in 30 days', lv_in_30.
WRITE: / 'difference', lv_days.

" Offsets work because the type is really a character field. This is also why
" a date can hold nonsense: nothing stops you writing '20261332' into it.
WRITE: / 'year      ', lv_today(4).
WRITE: / 'month     ', lv_today+4(2).
WRITE: / 'day       ', lv_today+6(2).

" sy-datum is the application server's date in the user's time zone; a
" timestamp is the unambiguous one, and it needs a zone to become a date again.
GET TIME STAMP FIELD DATA(lv_stamp).
CONVERT TIME STAMP lv_stamp TIME ZONE sy-zonlo
        INTO DATE DATA(lv_local_date) TIME DATA(lv_local_time).
WRITE: / 'stamp     ', lv_stamp.
WRITE: / 'local date', lv_local_date.
WRITE: / 'local time', lv_local_time.

" The initial value of a date is '00000000' -- not a null, and not a date. Test
" for it with IS INITIAL rather than comparing to a literal.
DATA lv_empty TYPE d.
IF lv_empty IS INITIAL.
  WRITE: / 'an unset date is initial, not null'.
ENDIF.
