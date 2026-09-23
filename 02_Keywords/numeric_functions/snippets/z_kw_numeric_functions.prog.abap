REPORT z_kw_numeric_functions.

DATA(lv_x) = CONV decfloat34( '-7.5' ).

" Each of these returns a value, so they nest and sit inside expressions.
WRITE: / 'abs  ', abs( lv_x ).
WRITE: / 'sign ', sign( lv_x ).
WRITE: / 'ceil ', ceil( lv_x ).
WRITE: / 'floor', floor( lv_x ).
WRITE: / 'trunc', trunc( lv_x ).
WRITE: / 'frac ', frac( lv_x ).

" round( ) takes the decimals and the MODE, spelled out. Leave the mode out
" and you get commercial rounding, which is not what every reader assumes.
WRITE: / 'round half up  ', round( val = lv_x dec = 0 mode = cl_abap_math=>round_half_up ).
WRITE: / 'round half even', round( val = lv_x dec = 0 mode = cl_abap_math=>round_half_even ).

WRITE: / 'nmax', nmax( val1 = 3 val2 = 9 ).
WRITE: / 'nmin', nmin( val1 = 3 val2 = 9 ).
WRITE: / 'ipow', ipow( base = 2 exp = 10 ).

" DIV and MOD are the integer operators. The slash is not: with integer
" operands it still ROUNDS, so 7 / 2 lands on 4, not 3.
DATA(lv_div) = 7 DIV 2.
DATA(lv_mod) = 7 MOD 2.
DATA(lv_sla) = 7 / 2.
WRITE: / '7 DIV 2', lv_div.
WRITE: / '7 MOD 2', lv_mod.
WRITE: / '7 / 2  ', lv_sla.

" MOD of a negative number is never negative in ABAP -- unlike C's %.
DATA(lv_neg) = -7 MOD 2.
WRITE: / '-7 MOD 2', lv_neg.
