REPORT z_tp_regex.

DATA(lv_line) = `Order 4711 for customer 10001973 on 2026-09-22`.

" PCRE is the syntax to use from 7.55 onward: it is the flavour the rest of the
" world writes, and it is faster than the POSIX engine behind FIND REGEX.
FIND FIRST OCCURRENCE OF PCRE `(\d{4})-(\d{2})-(\d{2})` IN lv_line
     SUBMATCHES DATA(lv_year) DATA(lv_month) DATA(lv_day).
IF sy-subrc = 0.
  WRITE: / 'date parts', lv_year, lv_month, lv_day.
ENDIF.

" Counting, as an expression rather than a statement.
DATA(lv_numbers) = count( val = lv_line pcre = `\d+` ).
WRITE: / 'number groups', lv_numbers.

" A test that reads as a condition.
IF matches( val = `10001973` pcre = `^\d{8}$` ).
  WRITE: / 'that is an eight digit number'.
ENDIF.

" Replacing, with $1 naming the first capture group.
DATA(lv_masked) = replace( val  = lv_line
                           pcre = `customer (\d{4})\d{4}`
                           with = `customer $1****`
                           occ  = 0 ).
WRITE: / 'masked   ', lv_masked.

" ALL OCCURRENCES ... RESULTS gives every match with its offset and length,
" which is what you need when the matches must be processed, not just counted.
FIND ALL OCCURRENCES OF PCRE `\d+` IN lv_line RESULTS DATA(lt_hits).
LOOP AT lt_hits INTO DATA(ls_hit).
  WRITE: / 'hit at', ls_hit-offset, 'length', ls_hit-length.
ENDLOOP.
