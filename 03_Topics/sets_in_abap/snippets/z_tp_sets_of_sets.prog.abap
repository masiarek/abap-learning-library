REPORT z_tp_sets_of_sets.

" A set, as on the rest of the page: the whole line is a UNIQUE key.
TYPES ty_set TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.

" A frozen set: a flat, canonical key that stands for the set, with the
" members carried along. The key is what the outer table hashes and compares.
TYPES: BEGIN OF ty_frozen,
         key     TYPE string,
         members TYPE ty_set,
       END OF ty_frozen.

" A set of sets: a hashed table of frozen sets, unique on the key alone.
TYPES ty_set_of_sets TYPE HASHED TABLE OF ty_frozen WITH UNIQUE KEY key.

" The only constant a table can be is an empty one: VALUE IS INITIAL.
CONSTANTS gc_empty TYPE ty_set VALUE IS INITIAL.

CLASS lcl_frozen DEFINITION FINAL.
  PUBLIC SECTION.
    " IMPORTING by reference: the method may read s and may not change it.
    CLASS-METHODS freeze
      IMPORTING s             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_frozen.
ENDCLASS.

CLASS lcl_frozen IMPLEMENTATION.
  METHOD freeze.
    " A sorted unique table has one order for one content, so equal sets give
    " equal strings. The comma after every member keeps {1, 2} and {12} apart.
    result-members = s.
    result-key = REDUCE string( INIT k = `` FOR n IN s NEXT k = |{ k }{ n },| ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA lt_family TYPE ty_set_of_sets.

  " {1, 2} and {2, 1} are one set: the second INSERT is refused, sy-subrc = 4.
  INSERT lcl_frozen=>freeze( VALUE #( ( 1 ) ( 2 ) ) ) INTO TABLE lt_family.
  INSERT lcl_frozen=>freeze( VALUE #( ( 2 ) ( 1 ) ) ) INTO TABLE lt_family.
  IF sy-subrc = 4.
    WRITE: / '{2, 1} refused: it is {1, 2} again'.
  ENDIF.
  INSERT lcl_frozen=>freeze( VALUE #( ( 3 ) ) ) INTO TABLE lt_family.
  INSERT lcl_frozen=>freeze( gc_empty ) INTO TABLE lt_family.
  WRITE: / 'sets in the family:', lines( lt_family ).

  " Membership of a set in the family: freeze the question the same way.
  DATA(ls_probe) = lcl_frozen=>freeze( VALUE #( ( 2 ) ( 1 ) ) ).
  IF line_exists( lt_family[ key = ls_probe-key ] ).
    WRITE: / '{1, 2} is a member'.
  ENDIF.

  " The key of a line in a hashed or sorted table is write-protected. Through
  " a field symbol, writing it is a runtime error, not a syntax error:
  "   <ls_set>-key = `9,`.
  " The members are NOT key, so nothing stops this line from changing them
  " and leaving the key describing a set that is no longer there. Freeze by
  " convention, or hide the members behind a class; the type will not do it.
  LOOP AT lt_family ASSIGNING FIELD-SYMBOL(<ls_set>).
    WRITE: / '{', <ls_set>-key, '} has', lines( <ls_set>-members ), 'members'.
  ENDLOOP.
