REPORT z_kw_string_templates.

DATA(lv_name)  = `Ada`.
DATA(lv_count) = 7.

" Everything between the bars is literal text; everything inside braces is an
" expression, converted to text on the spot.
DATA(lv_msg) = |Hello, { lv_name }! You have { lv_count } message(s).|.
WRITE: / lv_msg.

" Formatting options live inside the braces, after the expression.
WRITE: / |padded: [{ lv_count WIDTH = 5 ALIGN = RIGHT PAD = '0' }]|.
WRITE: / |upper : { lv_name CASE = UPPER }|.
WRITE: / |date  : { sy-datum DATE = USER }|.
WRITE: / |time  : { sy-uzeit TIME = USER }|.
WRITE: / |number: { CONV decfloat34( '1234.5' ) NUMBER = USER }|.

" A bar, a brace or a backslash inside a template has to be escaped.
WRITE: / |a pipe \| and a brace \{ are escaped with a backslash|.

" && joins strings; it is not the same as the old CONCATENATE, which needed a
" target and had its own rules about trailing blanks.
DATA(lv_joined) = lv_name && ` and ` && `Grace`.
WRITE: / lv_joined.

" A template always produces a string. Writing one into a fixed-length field
" truncates without a word.
DATA lv_short TYPE c LENGTH 5.
lv_short = |{ lv_joined }|.
WRITE: / 'truncated:', lv_short.
