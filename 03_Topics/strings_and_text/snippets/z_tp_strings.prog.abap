REPORT z_tp_strings.

DATA(lv_text) = `  Ada Lovelace, Analytical Engine  `.

" The built-in functions return a value, so they nest and compose. The old
" statements (CONDENSE, TRANSLATE, SHIFT) change a variable in place instead,
" which is why they cannot appear inside an expression.
WRITE: / 'condensed [', condense( lv_text ), ']'.
WRITE: / 'upper     ', to_upper( lv_text ).
WRITE: / 'length    ', strlen( condense( lv_text ) ).

" Offsets count from zero and are not bounds-checked by the compiler.
DATA(lv_name) = condense( lv_text ).
WRITE: / 'first 3   ', lv_name(3).
WRITE: / 'substring ', substring( val = lv_name off = 0 len = 3 ).

" Searching: find( ) returns the offset or -1, and never raises.
DATA(lv_at) = find( val = lv_name sub = `Engine` ).
WRITE: / 'found at  ', lv_at.

" Splitting into a table, then joining back with a separator of your choice.
SPLIT lv_name AT `,` INTO TABLE DATA(lt_parts).
WRITE: / 'parts     ', lines( lt_parts ).
DATA(lv_joined) = concat_lines_of( table = lt_parts sep = ` | ` ).
WRITE: / 'joined    ', lv_joined.

" replace( ) returns a new string; REPLACE ... IN changes one in place.
WRITE: / 'replaced  ', replace( val = lv_name sub = `Ada` with = `Grace` ).

" A string grows as needed; a c field is padded to its length forever, and
" comparing the two is the oldest source of surprise in ABAP.
DATA lv_fixed TYPE c LENGTH 10 VALUE 'Ada'.
DATA(lv_string) = `Ada`.
IF lv_fixed = lv_string.
  WRITE: / 'c and string compare equal -- trailing blanks are ignored here'.
ENDIF.
WRITE: / 'c strlen     ', strlen( lv_fixed ).
WRITE: / 'string strlen', strlen( lv_string ).
