REPORT z_tp_sets_in_abap.

" ABAP has no set type. A set is an internal table whose whole line is a
" UNIQUE key -- a sorted one here, so every set also prints in order.
TYPES ty_set  TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.
TYPES ty_list TYPE STANDARD TABLE OF i WITH EMPTY KEY.

" Each set operation is one idiom; the class only gives the idioms names.
CLASS lcl_set DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS union
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_set.
    CLASS-METHODS intersect
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_set.
    CLASS-METHODS minus
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_set.
    CLASS-METHODS xor
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_set.
    CLASS-METHODS is_subset
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE abap_bool.
    CLASS-METHODS show
      IMPORTING label TYPE string
                s     TYPE ty_set.
ENDCLASS.

CLASS lcl_set IMPLEMENTATION.
  METHOD union.
    " INSERT LINES OF into a unique table dumps on a duplicate key, where a
    " single INSERT only sets sy-subrc = 4. So add just what A lacks.
    result = a.
    DATA(lt_new) = FILTER #( b EXCEPT IN a WHERE table_line = table_line ).
    INSERT LINES OF lt_new INTO TABLE result.
  ENDMETHOD.

  METHOD intersect.
    " Keep the lines of A that have a partner in B. B is searched by its key.
    result = FILTER #( a IN b WHERE table_line = table_line ).
  ENDMETHOD.

  METHOD minus.
    " Keep the lines of A that have NO partner in B.
    result = FILTER #( a EXCEPT IN b WHERE table_line = table_line ).
  ENDMETHOD.

  METHOD xor.
    " In exactly one of the two: (A - B) together with (B - A).
    result = union( a = minus( a = a b = b ) b = minus( a = b b = a ) ).
  ENDMETHOD.

  METHOD is_subset.
    " A is a subset of B when nothing is left of A after removing B.
    result = xsdbool( lines( minus( a = a b = b ) ) = 0 ).
  ENDMETHOD.

  METHOD show.
    DATA(lv_text) = ``.
    LOOP AT s INTO DATA(lv_n).
      lv_text = |{ lv_text } { lv_n }|.
    ENDLOOP.
    WRITE: / label, '= {', lv_text, '}'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA(lt_a) = VALUE ty_set( ( 0 ) ( 1 ) ( 2 ) ( 3 ) ( 4 ) ).
  DATA(lt_b) = VALUE ty_set( ( 2 ) ( 3 ) ( 4 ) ).
  DATA(lt_c) = VALUE ty_set( ( 2 ) ( 5 ) ).

  " Membership is a keyed read: binary search here, one step on a hashed set.
  IF line_exists( lt_a[ table_line = 3 ] ).
    WRITE: / '3 is in A'.
  ENDIF.

  " Building a set: INSERT refuses a repeat with sy-subrc = 4, and no dump.
  DATA lt_seen TYPE ty_set.
  DATA(lt_raw) = VALUE ty_list( ( 3 ) ( 1 ) ( 3 ) ( 2 ) ( 1 ) ).
  LOOP AT lt_raw INTO DATA(lv_n).
    INSERT lv_n INTO TABLE lt_seen.
    IF sy-subrc = 4.
      WRITE: / 'repeat refused:', lv_n.
    ENDIF.
  ENDLOOP.
  lcl_set=>show( label = `seen` s = lt_seen ).

  " The same result for a list you cannot retype: sort, then drop neighbours.
  DATA(lt_dedup) = lt_raw.
  SORT lt_dedup BY table_line.
  DELETE ADJACENT DUPLICATES FROM lt_dedup COMPARING ALL FIELDS.
  WRITE: / 'deduplicated list has', lines( lt_dedup ), 'lines'.

  lcl_set=>show( label = `A | B` s = lcl_set=>union( a = lt_a b = lt_b ) ).
  lcl_set=>show( label = `A & B` s = lcl_set=>intersect( a = lt_a b = lt_b ) ).
  lcl_set=>show( label = `A - B` s = lcl_set=>minus( a = lt_a b = lt_b ) ).
  lcl_set=>show( label = `A ^ B` s = lcl_set=>xor( a = lt_a b = lt_b ) ).

  " Chained, symmetric difference keeps what is in an ODD number of the sets:
  " 2 is in all three, so it comes back.
  lcl_set=>show( label = `A ^ B ^ C`
                 s     = lcl_set=>xor( a = lcl_set=>xor( a = lt_a b = lt_b )
                                       b = lt_c ) ).

  IF lcl_set=>is_subset( a = lt_b b = lt_a ) = abap_true.
    WRITE: / 'B is a subset of A'.
  ENDIF.

  " = on two tables compares line by line, in order. Two lists holding the
  " same numbers in a different order are NOT equal ...
  DATA(lt_x) = VALUE ty_list( ( 1 ) ( 2 ) ( 3 ) ).
  DATA(lt_y) = VALUE ty_list( ( 3 ) ( 2 ) ( 1 ) ).
  IF lt_x <> lt_y.
    WRITE: / 'as lists, 1 2 3 <> 3 2 1'.
  ENDIF.

  " ... while a sorted unique table has one order for one content, so for it
  " = is set equality.
  DATA(lt_sx) = VALUE ty_set( ( 1 ) ( 2 ) ( 3 ) ).
  DATA(lt_sy) = VALUE ty_set( ( 3 ) ( 2 ) ( 1 ) ).
  IF lt_sx = lt_sy.
    WRITE: / 'as sorted sets, {1 2 3} = {3 2 1}'.
  ENDIF.
