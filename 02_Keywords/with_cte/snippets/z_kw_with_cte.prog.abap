REPORT z_kw_with_cte.

" WITH (7.51+) names a subquery once and uses it like a table in the main
" SELECT -- Open SQL's common table expression. Each name starts with +.
WITH
  +busy AS (
    SELECT carrid, connid, fldate, seatsocc
      FROM sflight
      WHERE seatsocc > 0 ),
  +per_carrier AS (
    SELECT carrid, COUNT(*) AS flights, SUM( seatsocc ) AS occupied
      FROM +busy
      GROUP BY carrid )
  SELECT p~carrid, s~carrname, p~flights, p~occupied
    FROM +per_carrier AS p
    INNER JOIN scarr AS s ON s~carrid = p~carrid
    ORDER BY p~carrid
    INTO TABLE @DATA(lt_result).

LOOP AT lt_result INTO DATA(ls_r).
  WRITE: / ls_r-carrid, ls_r-carrname, ls_r-flights, ls_r-occupied.
ENDLOOP.
WRITE: / 'carriers with busy flights', lines( lt_result ).
