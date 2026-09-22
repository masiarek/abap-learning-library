REPORT z_kw_message.

PARAMETERS p_qty TYPE i DEFAULT 0.

START-OF-SELECTION.

  " The literal form: a text, a type, no message class needed. Fine for a
  " throwaway; it cannot be translated, so it does not belong in shipped code.
  IF p_qty = 0.
    MESSAGE 'Quantity is zero' TYPE 'S'.
  ENDIF.

  " sy-msgid, sy-msgno and sy-msgv1..4 hold the last message raised. A BAPI
  " hands its problems back in exactly these pieces, inside its RETURN table.
  WRITE: / 'last message type', sy-msgty.

  " Capturing a message instead of displaying it -- MESSAGE ... INTO -- needs a
  " message from a message class, not a text literal. That form is on the page;
  " it is left out here because this program would then need a message class
  " that your system does not have.

  " The type is not cosmetic: it decides what happens next.
  "   'S' status line, program continues      'I' dialog box, then continues
  "   'W' warning, behaves like E in batch    'E' error, stops the step
  "   'A' abend, ends the transaction         'X' short dump on purpose
  IF p_qty < 0.
    MESSAGE 'Quantity cannot be negative' TYPE 'E'.
  ENDIF.

  WRITE: / 'quantity accepted:', p_qty.
