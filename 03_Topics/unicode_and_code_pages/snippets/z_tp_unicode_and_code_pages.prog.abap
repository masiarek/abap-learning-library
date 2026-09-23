REPORT z_tp_unicode_and_code_pages.

" ABAP source should not carry non-ASCII characters (this library's linter
" refuses them, and transports have mangled them), so the Polish word is
" built from code points: Z a z-dot o-acute l-stroke c-acute.
DATA(lv_text) = `Za`
             && cl_abap_conv_in_ce=>uccp( '017C' )
             && cl_abap_conv_in_ce=>uccp( '00F3' )
             && cl_abap_conv_in_ce=>uccp( '0142' )
             && cl_abap_conv_in_ce=>uccp( '0107' ).

" Characters against bytes: strlen counts UTF-16 units, the byte count
" depends entirely on which code page you name.
WRITE: / 'strlen        ', strlen( lv_text ).

DATA(lv_utf8)  = cl_abap_conv_codepage=>create_out( codepage = `UTF-8` )->convert( lv_text ).
DATA(lv_utf16) = cl_abap_conv_codepage=>create_out( codepage = `UTF-16BE` )->convert( lv_text ).
WRITE: / 'UTF-8 bytes   ', xstrlen( lv_utf8 ).
WRITE: / 'UTF-16 bytes  ', xstrlen( lv_utf16 ).

" A round trip through the same code page gives the text back.
DATA(lv_back) = cl_abap_conv_codepage=>create_in( codepage = `UTF-8` )->convert( lv_utf8 ).
IF lv_back = lv_text.
  WRITE: / 'round trip through UTF-8 preserved the text'.
ENDIF.

" Through the WRONG code page, the same bytes are a different text, and no
" exception says so. This is what an interface file looks like from the
" other side when the encoding was never agreed.
DATA(lv_wrong) = cl_abap_conv_codepage=>create_in( codepage = `ISO-8859-1` )->convert( lv_utf8 ).
WRITE: / 'same bytes read as Latin-1, strlen', strlen( lv_wrong ).
