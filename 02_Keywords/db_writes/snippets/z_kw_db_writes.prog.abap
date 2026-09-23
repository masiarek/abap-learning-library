REPORT z_kw_db_writes.

" Every statement here targets the flight demo table SFLIGHT, and the program
" ends in ROLLBACK WORK, so running it changes nothing. That is the lesson as
" much as the setup: nothing is written until a COMMIT WORK, and everything
" since the last one can still be taken back.
DATA ls_flight TYPE sflight.

SELECT SINGLE * FROM sflight INTO @ls_flight.
IF sy-subrc <> 0.
  WRITE: / 'no demo data in SFLIGHT; nothing to show'.
  RETURN.
ENDIF.

" INSERT refuses a duplicate key: sy-subrc 4, no dump, nothing inserted.
INSERT sflight FROM @ls_flight.
WRITE: / 'insert of an existing key ->', sy-subrc.

" UPDATE by key, one column. sy-dbcnt says how many rows were touched, which
" is the number to check when a WHERE was meant to hit exactly one.
DATA(lv_more) = ls_flight-seatsocc + 1.
UPDATE sflight SET seatsocc = @lv_more
  WHERE carrid = @ls_flight-carrid
    AND connid = @ls_flight-connid
    AND fldate = @ls_flight-fldate.
WRITE: / 'rows updated', sy-dbcnt.

" MODIFY inserts or updates, whichever applies -- and does not say which.
ls_flight-seatsocc = ls_flight-seatsocc + 2.
MODIFY sflight FROM @ls_flight.
WRITE: / 'modify ->', sy-subrc.

" DELETE with a WHERE. A DELETE with no condition at all is a syntax error,
" which is the one guard rail the statement has.
DELETE FROM sflight
  WHERE carrid = @ls_flight-carrid
    AND connid = @ls_flight-connid
    AND fldate = @ls_flight-fldate.
WRITE: / 'rows deleted', sy-dbcnt.

ROLLBACK WORK.
WRITE: / 'rolled back: SFLIGHT is exactly as it was'.
