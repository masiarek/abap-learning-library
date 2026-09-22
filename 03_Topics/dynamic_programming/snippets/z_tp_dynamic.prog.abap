REPORT z_tp_dynamic.

PARAMETERS p_table TYPE tabname DEFAULT 'SCARR'.
PARAMETERS p_field TYPE fieldname DEFAULT 'CARRNAME'.

START-OF-SELECTION.

  " A table named at runtime. Everything the compiler would normally check --
  " does the table exist, does the field, may this user read it -- moves to
  " runtime, and so does every error.
  DATA lr_rows TYPE REF TO data.
  FIELD-SYMBOLS <lt_rows> TYPE STANDARD TABLE.
  FIELD-SYMBOLS <lv_value> TYPE any.

  CREATE DATA lr_rows TYPE STANDARD TABLE OF (p_table).
  ASSIGN lr_rows->* TO <lt_rows>.

  SELECT * FROM (p_table)
    INTO TABLE @<lt_rows>
    UP TO 5 ROWS.

  " Reading a component whose name is only known now.
  LOOP AT <lt_rows> ASSIGNING FIELD-SYMBOL(<ls_row>).
    ASSIGN COMPONENT p_field OF STRUCTURE <ls_row> TO <lv_value>.
    IF sy-subrc = 0.
      WRITE: / <lv_value>.
    ELSE.
      WRITE: / 'no such field in this table'.
      EXIT.
    ENDIF.
  ENDLOOP.

  " Calling a method whose name is a string. The same trade: no compiler, no
  " where-used list, and a refactoring tool cannot see this call at all.
  DATA(lv_method) = `GET_TEXT`.
  DATA(lo_error) = NEW cx_sy_zerodivide( ).
  DATA lv_text TYPE string.
  CALL METHOD lo_error->(lv_method)
    RECEIVING
      result = lv_text.
  WRITE: / lv_text.
