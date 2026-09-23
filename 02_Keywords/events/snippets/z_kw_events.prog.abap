REPORT z_kw_events.

CLASS lcl_button DEFINITION.
  PUBLIC SECTION.
    EVENTS clicked EXPORTING VALUE(iv_times) TYPE i.
    METHODS click.
  PRIVATE SECTION.
    DATA mv_times TYPE i.
ENDCLASS.

CLASS lcl_button IMPLEMENTATION.
  METHOD click.
    mv_times = mv_times + 1.
    " Raising the event runs every registered handler, synchronously, before
    " the next statement here. No handler registered: no effect, no error.
    RAISE EVENT clicked EXPORTING iv_times = mv_times.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_logger DEFINITION.
  PUBLIC SECTION.
    " A handler names the event and the class it belongs to. Its parameters
    " are a subset of the event's, with the same names.
    METHODS on_clicked FOR EVENT clicked OF lcl_button
      IMPORTING iv_times.
ENDCLASS.

CLASS lcl_logger IMPLEMENTATION.
  METHOD on_clicked.
    WRITE: / 'clicked', iv_times, 'time(s)'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA(lo_button) = NEW lcl_button( ).
  DATA(lo_logger) = NEW lcl_logger( ).

  lo_button->click( ).                 " nobody is listening yet

  SET HANDLER lo_logger->on_clicked FOR lo_button.
  lo_button->click( ).
  lo_button->click( ).

  " Registration is per handler and per object; ACTIVATION abap_false undoes it.
  SET HANDLER lo_logger->on_clicked FOR lo_button ACTIVATION abap_false.
  lo_button->click( ).                 " silent again
  WRITE: / 'done'.
