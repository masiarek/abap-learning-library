REPORT z_kw_select.

" The flight demo tables ship with most training and sandbox systems. Swap them
" for your own; the shape of each statement is the point.
PARAMETERS p_carr TYPE scarr-carrid DEFAULT 'LH'.

START-OF-SELECTION.

  " One row, named columns. SINGLE without a full key is a coin toss, so give
  " it the key -- and check sy-subrc, because a miss leaves the target initial.
  SELECT SINGLE carrid, carrname
    FROM scarr
    WHERE carrid = @p_carr
    INTO @DATA(ls_carrier).
  IF sy-subrc = 0.
    WRITE: / 'carrier', ls_carrier-carrname.
  ENDIF.

  " Many rows, straight into an internal table the compiler declares for you.
  SELECT carrid, connid, fldate, seatsocc
    FROM sflight
    WHERE carrid = @p_carr
    ORDER BY fldate DESCENDING
    INTO TABLE @DATA(lt_flights)
    UP TO 10 ROWS.
  WRITE: / 'flights', lines( lt_flights ).

  " A join and an aggregate: work the database is built for, and a loop in ABAP
  " is not. Every non-aggregated column has to appear in GROUP BY.
  SELECT f~carrid, c~carrname, SUM( f~seatsocc ) AS occupied
    FROM sflight AS f
    INNER JOIN scarr AS c ON c~carrid = f~carrid
    WHERE f~carrid = @p_carr
    GROUP BY f~carrid, c~carrname
    INTO TABLE @DATA(lt_totals).

  LOOP AT lt_totals INTO DATA(ls_total).
    WRITE: / ls_total-carrname, ls_total-occupied.
  ENDLOOP.

  " Reading inside a loop is the classic performance bug. Read once, then look
  " up in memory -- a sorted or hashed table makes the lookup cheap.
  SELECT carrid, carrname
    FROM scarr
    INTO TABLE @DATA(lt_names).
  LOOP AT lt_flights INTO DATA(ls_flight).
    DATA(ls_name) = VALUE #( lt_names[ carrid = ls_flight-carrid ] OPTIONAL ).
    WRITE: / ls_flight-fldate, ls_name-carrname.
  ENDLOOP.
