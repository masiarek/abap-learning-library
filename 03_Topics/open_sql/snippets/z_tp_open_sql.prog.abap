REPORT z_tp_open_sql.

START-OF-SELECTION.

  SELECT carrid, connid, fldate, seatsocc
    FROM sflight
    INTO TABLE @DATA(lt_flights)
    UP TO 20 ROWS.

  " FOR ALL ENTRIES has two traps and both are silent.
  " 1) An EMPTY driver table does not select nothing -- it drops the WHERE
  "    condition and selects EVERYTHING. Guard it.
  " 2) The result is de-duplicated on the selected columns, so rows you expected
  "    can vanish unless the key is in the field list.
  IF lt_flights IS NOT INITIAL.
    SELECT carrid, carrname
      FROM scarr
      FOR ALL ENTRIES IN @lt_flights
      WHERE carrid = @lt_flights-carrid
      INTO TABLE @DATA(lt_carriers).
    WRITE: / 'carriers', lines( lt_carriers ).
  ENDIF.

  " Aggregates come back from the database; every non-aggregated column of the
  " result must be listed in GROUP BY, and a condition ON an aggregate is
  " HAVING, not WHERE.
  SELECT carrid, COUNT(*) AS flights, SUM( seatsocc ) AS occupied
    FROM sflight
    GROUP BY carrid
    HAVING SUM( seatsocc ) > 0
    ORDER BY carrid
    INTO TABLE @DATA(lt_totals).

  LOOP AT lt_totals INTO DATA(ls_total).
    WRITE: / ls_total-carrid, ls_total-flights, ls_total-occupied.
  ENDLOOP.

  " An outer join keeps the left rows that have no partner, and fills the right
  " side with initial values -- which look exactly like real zeroes later on.
  SELECT c~carrid, c~carrname, f~connid
    FROM scarr AS c
    LEFT OUTER JOIN sflight AS f ON f~carrid = c~carrid
    INTO TABLE @DATA(lt_left)
    UP TO 20 ROWS.
  WRITE: / 'left join rows', lines( lt_left ).
