REPORT z_tp_sets_sql.

" The flight demo tables ship with most training and sandbox systems. Swap them
" for your own; the set operator is the point.

START-OF-SELECTION.

  " SELECT DISTINCT: the result set as a set, duplicates removed by the database.
  SELECT DISTINCT carrid
    FROM spfli
    INTO TABLE @DATA(lt_carriers).
  WRITE: / 'carriers with a connection', lines( lt_carriers ).

  " UNION is UNION DISTINCT: a carrier flying both from and to Germany appears
  " once. UNION ALL would keep both rows. INTO comes after the last query.
  SELECT carrid FROM spfli WHERE countryfr = 'DE'
  UNION
  SELECT carrid FROM spfli WHERE countryto = 'DE'
    INTO TABLE @DATA(lt_from_or_to).
  WRITE: / 'from or to DE', lines( lt_from_or_to ).

  " INTERSECT: in both result sets.
  SELECT carrid FROM spfli WHERE countryfr = 'DE'
  INTERSECT
  SELECT carrid FROM spfli WHERE countryto = 'DE'
    INTO TABLE @DATA(lt_from_and_to).
  WRITE: / 'from and to DE', lines( lt_from_and_to ).

  " EXCEPT: in the first result set and not in the second.
  SELECT carrid FROM spfli WHERE countryfr = 'DE'
  EXCEPT
  SELECT carrid FROM spfli WHERE countryto = 'DE'
    INTO TABLE @DATA(lt_from_not_to).
  WRITE: / 'from but not to DE', lines( lt_from_not_to ).
