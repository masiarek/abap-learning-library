REPORT z_kw_report_events.

PARAMETERS p_qty TYPE i DEFAULT 1.

DATA gv_checked TYPE abap_bool.

INITIALIZATION.
  " Once, before the selection screen appears. A default that needs code --
  " last month, the user's company code -- goes here, not in DEFAULT.
  p_qty = 5.

AT SELECTION-SCREEN ON p_qty.
  " After input, for this one field. An E message here returns to the screen
  " with the field open for correction; the same message later would not.
  IF p_qty < 0.
    MESSAGE 'Quantity cannot be negative' TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN.
  " After input, once, for checks that involve more than one field.
  gv_checked = abap_true.

START-OF-SELECTION.
  " The report proper. Statements after the declarations and before the first
  " event keyword ALSO land here, implicitly -- write the keyword.
  WRITE: / 'processing quantity', p_qty.
  WRITE: / 'validated', gv_checked.

END-OF-SELECTION.
  " After START-OF-SELECTION has finished (and, with a logical database, after
  " it has delivered its last record).
  WRITE: / 'done'.

TOP-OF-PAGE.
  " Before the first line of each list page -- the place for a page header.
  WRITE: / 'Report events, in the order they fire'.
  ULINE.
