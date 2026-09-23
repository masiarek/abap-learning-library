REPORT z_tp_conversion_and_comparison.

" Assignment converts silently between most elementary types. What each
" conversion does with the part it cannot keep is the whole subject.
DATA lv_c4 TYPE c LENGTH 4.
DATA lv_n4 TYPE n LENGTH 4.
DATA lv_i  TYPE i.
DATA lv_p2 TYPE p LENGTH 5 DECIMALS 2.

lv_c4 = 'ABCDEFG'.              " longer text into c: cut on the right
WRITE: / 'c4 from ABCDEFG   [', lv_c4, ']'.

lv_n4 = '12ab34'.               " text into n: non-digits dropped, right-aligned
WRITE: / 'n4 from 12ab34    [', lv_n4, ']'.

lv_i = '  42 '.                 " numeric text into i: blanks tolerated
WRITE: / 'i  from "  42 "   ', lv_i.

lv_i = '3.7'.                   " decimal text into i: rounded, not truncated
WRITE: / 'i  from 3.7       ', lv_i.

lv_p2 = '1.005'.                " more decimals than the target: rounded
WRITE: / 'p2 from 1.005     ', lv_p2.

" A conversion that cannot be made at all raises at runtime.
TRY.
    lv_i = 'forty-two'.
    WRITE: / 'never reached', lv_i.
  CATCH cx_sy_conversion_no_number.
    WRITE: / 'text that is not a number: CX_SY_CONVERSION_NO_NUMBER'.
ENDTRY.

" Comparison converts too, by a table of comparison types. c against n is
" compared as TEXT, so '0042' and '42' differ; n against i as NUMBERS, so
" they do not. The program prints what your system does with each.
lv_n4 = 42.
IF lv_n4 = '42'.
  WRITE: / 'n4 = c 42 :  equal'.
ELSE.
  WRITE: / 'n4 = c 42 :  not equal (compared as text)'.
ENDIF.
IF lv_n4 = 42.
  WRITE: / 'n4 = i 42 :  equal (compared as numbers)'.
ENDIF.

" And the one everyone meets: a c field against a string ignores trailing
" blanks, so 'Ada       ' and `Ada` are equal here and unequal in strlen( ).
DATA lv_fixed TYPE c LENGTH 10 VALUE 'Ada'.
IF lv_fixed = `Ada`.
  WRITE: / 'c and string: equal, trailing blanks ignored'.
ENDIF.
