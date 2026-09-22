REPORT z_kw_filter.

TYPES: BEGIN OF ty_row,
         region TYPE string,
         active TYPE abap_bool,
         name   TYPE string,
       END OF ty_row.
" FILTER needs a key it can search on, so the source table is declared with one.
TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH NON-UNIQUE SORTED KEY by_region
                                           COMPONENTS region.

DATA(lt_rows) = VALUE ty_tab( ( region = `EU` active = abap_true  name = `Ada` )
                              ( region = `US` active = abap_false name = `Grace` )
                              ( region = `EU` active = abap_false name = `Mary` ) ).

" FILTER keeps the rows that match a condition on the named key.
DATA(lt_eu) = FILTER #( lt_rows USING KEY by_region WHERE region = `EU` ).
WRITE: / 'eu rows', lines( lt_eu ).

" EXCEPT inverts it: keep what does NOT match.
DATA(lt_not_eu) = FILTER #( lt_rows EXCEPT USING KEY by_region WHERE region = `EU` ).
WRITE: / 'other rows', lines( lt_not_eu ).

" The same job written as a loop, for comparison. FILTER is shorter; it is also
" limited to conditions on a key, which is why LOOP never goes away.
DATA lt_manual TYPE ty_tab.
LOOP AT lt_rows INTO DATA(ls_row) WHERE region = `EU`.
  APPEND ls_row TO lt_manual.
ENDLOOP.
WRITE: / 'manual  ', lines( lt_manual ).
