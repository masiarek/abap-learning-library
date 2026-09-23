REPORT z_kw_at_new.

TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
TYPES: BEGIN OF ty_row,
         region TYPE c LENGTH 2,
         city   TYPE c LENGTH 10,
         amount TYPE ty_amount,
       END OF ty_row.
TYPES ty_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

DATA(lt_rows) = VALUE ty_rows( ( region = 'EU' city = 'Paris'  amount = '10.00' )
                               ( region = 'US' city = 'Boston' amount = '20.00' )
                               ( region = 'EU' city = 'Rome'   amount = '30.00' ) ).

" A control break compares with the PREVIOUS row, so the table must be sorted
" by the break fields, in that order, or the breaks fire at random.
SORT lt_rows BY region city.

LOOP AT lt_rows INTO DATA(ls_row).
  AT FIRST.
    WRITE: / 'start'.
  ENDAT.

  AT NEW region.
    " Inside AT NEW, every component AFTER the break field is masked with
    " asterisks in the work area: ls_row-city is not readable here.
    WRITE: / 'region', ls_row-region.
  ENDAT.

  WRITE: / '  ', ls_row-city, ls_row-amount.

  AT END OF region.
    " SUM fills the numeric components of the work area with the group totals.
    SUM.
    WRITE: / '  subtotal', ls_row-amount.
  ENDAT.

  AT LAST.
    SUM.
    WRITE: / 'grand total', ls_row-amount.
  ENDAT.
ENDLOOP.
