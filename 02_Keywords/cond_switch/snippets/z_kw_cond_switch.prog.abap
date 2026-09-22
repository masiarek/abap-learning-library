REPORT z_kw_cond_switch.

DATA(lv_score) = 72.

" COND tests conditions, in order, and stops at the first that holds.
DATA(lv_grade) = COND string( WHEN lv_score >= 90 THEN `A`
                              WHEN lv_score >= 80 THEN `B`
                              WHEN lv_score >= 70 THEN `C`
                              ELSE `F` ).

" SWITCH compares one operand against values. It cannot express a range.
DATA(lv_band) = SWITCH string( lv_grade
                               WHEN `A` OR `B` THEN `distinction`
                               WHEN `C`        THEN `pass`
                               ELSE `fail` ).

" Without ELSE the result is the initial value of the type -- a silent empty
" string, not an error. THROW turns that gap into an exception instead.
TRY.
    DATA(lv_checked) = COND string( WHEN lv_score BETWEEN 0 AND 100 THEN lv_grade
                                    ELSE THROW cx_sy_conversion_error( ) ).
    WRITE: / 'checked', lv_checked.
  CATCH cx_sy_conversion_error.
    WRITE: / 'score out of range'.
ENDTRY.

WRITE: / 'grade', lv_grade.
WRITE: / 'band ', lv_band.
