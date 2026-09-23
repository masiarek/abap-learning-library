REPORT z_kw_ranges.

" A ranges table has four columns -- sign, option, low, high -- and one row
" per condition. SELECT-OPTIONS builds one for you; this builds one by hand.
TYPES ty_carrier_range TYPE RANGE OF scarr-carrid.

DATA(lt_carriers) = VALUE ty_carrier_range(
  ( sign = 'I' option = 'EQ' low = 'LH' )
  ( sign = 'I' option = 'EQ' low = 'AA' )
  ( sign = 'I' option = 'BT' low = 'DL' high = 'DZ' )
  ( sign = 'E' option = 'CP' low = 'X*' ) ).

" IN takes a ranges table in Open SQL ...
SELECT carrid, carrname
  FROM scarr
  WHERE carrid IN @lt_carriers
  INTO TABLE @DATA(lt_found).
WRITE: / 'carriers matched', lines( lt_found ).

" ... and in an ABAP condition, and in an internal table WHERE.
IF 'LH' IN lt_carriers.
  WRITE: / 'LH is inside the range'.
ENDIF.

" An EMPTY ranges table means NO restriction, not "nothing matches". On a
" selection screen that is the feature; everywhere else it is the trap.
DATA lt_none TYPE ty_carrier_range.
SELECT COUNT(*)
  FROM scarr
  WHERE carrid IN @lt_none
  INTO @DATA(lv_all).
WRITE: / 'empty range selects every carrier:', lv_all.
