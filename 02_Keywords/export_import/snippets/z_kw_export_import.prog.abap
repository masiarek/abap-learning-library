REPORT z_kw_export_import.

TYPES ty_names TYPE STANDARD TABLE OF string WITH EMPTY KEY.

DATA(lt_names) = VALUE ty_names( ( `Ada` ) ( `Grace` ) ).
DATA(lv_count) = lines( lt_names ).

" ABAP memory: lives as long as this session's call stack -- this program and
" anything it SUBMITs or CALL TRANSACTIONs. Several objects under one ID.
EXPORT names = lt_names
       count = lv_count
       TO MEMORY ID 'ZKW_DEMO'.

DATA lt_back TYPE ty_names.
DATA lv_back TYPE i.
IMPORT names = lt_back
       count = lv_back
       FROM MEMORY ID 'ZKW_DEMO'.
WRITE: / 'from ABAP memory', lv_back, lines( lt_back ).

" A miss is sy-subrc 4, not an exception, and the targets keep their values.
IMPORT names = lt_back FROM MEMORY ID 'NO_SUCH_ID'.
WRITE: / 'unknown id ->', sy-subrc.

FREE MEMORY ID 'ZKW_DEMO'.

" SAP memory: one value per parameter ID for the whole logon session, across
" programs and transactions. It is what pre-fills a screen field with the
" value you used last time.
SET PARAMETER ID 'CAR' FIELD 'LH'.
DATA lv_carrier TYPE scarr-carrid.
GET PARAMETER ID 'CAR' FIELD lv_carrier.
WRITE: / 'from SAP memory', lv_carrier.
