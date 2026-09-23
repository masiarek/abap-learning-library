REPORT z_tp_conversion_routines.

" A material number is stored with leading zeros and shown without them. The
" ALPHA conversion routine is the bridge, and a string template can apply it.
DATA lv_stored TYPE c LENGTH 18.

lv_stored = |{ '4711' ALPHA = IN }|.
WRITE: / 'in  (towards storage) [', lv_stored, ']'.

DATA(lv_shown) = |{ lv_stored ALPHA = OUT }|.
WRITE: / 'out (towards display) [', lv_shown, ']'.

" The function module form, which is what older code -- and most SAP code --
" calls. Every conversion routine XXXX has CONVERSION_EXIT_XXXX_INPUT/OUTPUT.
DATA lv_via_fm TYPE c LENGTH 18.
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = '4711'
  IMPORTING
    output = lv_via_fm.
WRITE: / 'via the function module [', lv_via_fm, ']'.

" The trap: a value typed on a screen ('4711') and the value in the table
" ('000000000000004711') are not equal until one side is converted -- and a
" SELECT with the unconverted one finds nothing, quietly.
IF lv_stored = '4711'.
  WRITE: / 'equal without conversion'.
ELSE.
  WRITE: / 'NOT equal until converted -- the classic ALPHA bug'.
ENDIF.
