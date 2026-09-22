REPORT z_kw_try_catch.

START-OF-SELECTION.

  " A runtime error like division by zero is a CX_DYNAMIC_CHECK: the compiler
  " does not force you to catch it, and it still ends the program if you do not.
  " The divisor is a variable on purpose -- 10 / 0 written out is caught at
  " compile time instead, which is a different lesson.
  DATA(lv_divisor) = 0.
  TRY.
      DATA(lv_result) = 10 / lv_divisor.
      WRITE: / 'result', lv_result.
    CATCH cx_sy_zerodivide INTO DATA(lx_zero).
      " The exception object carries the facts; get_text( ) is the human line.
      WRITE: / 'divide by zero:', lx_zero->get_text( ).
  ENDTRY.

  " Catching the wrong thing is worse than catching nothing: CX_ROOT here would
  " have swallowed a programming error along with the missing row.
  TYPES ty_ints TYPE STANDARD TABLE OF i WITH EMPTY KEY.
  DATA(lt_n) = VALUE ty_ints( ( 1 ) ( 2 ) ).
  TRY.
      DATA(lv_third) = lt_n[ 3 ].
      WRITE: / 'third', lv_third.
    CATCH cx_sy_itab_line_not_found.
      WRITE: / 'there is no third row'.
  ENDTRY.

  " CLEANUP runs when an exception leaves this TRY block unhandled -- the place
  " to close what you opened. It does not run when the block ends normally, and
  " it does not run when the exception is caught here.
  TRY.
      TRY.
          RAISE EXCEPTION TYPE cx_sy_conversion_error.
        CLEANUP.
          WRITE: / 'cleanup ran on the way out'.
      ENDTRY.
    CATCH cx_sy_conversion_error.
      WRITE: / 'caught one level up'.
  ENDTRY.

  " Several exceptions, one handler: list them after CATCH. The INTO variable
  " is then typed to their nearest common superclass.
  TRY.
      DATA(lv_again) = 1 / lv_divisor.
      WRITE: / lv_again.
    CATCH cx_sy_zerodivide cx_sy_conversion_error INTO DATA(lx_any).
      WRITE: / 'one of the two:', lx_any->get_text( ).
  ENDTRY.
