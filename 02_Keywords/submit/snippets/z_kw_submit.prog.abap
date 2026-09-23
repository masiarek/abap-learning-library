REPORT z_kw_submit.

" SUBMIT runs another executable program. AND RETURN comes back here when it
" finishes; without it, control never comes back at all.
SUBMIT z_kw_data AND RETURN.
WRITE: / 'back from z_kw_data'.

" Parameters and select-options are passed by their names on the called
" program's selection screen.
SUBMIT z_kw_select WITH p_carr = 'AA' AND RETURN.
WRITE: / 'back from z_kw_select'.

" EXPORTING LIST TO MEMORY keeps the called report's list off the screen so
" the caller can read it back (function module LIST_FROM_MEMORY). It is the
" pre-object way to reuse a report as a data source, and still common.
SUBMIT z_kw_data EXPORTING LIST TO MEMORY AND RETURN.
WRITE: / 'list captured in memory, not displayed'.

" VIA SELECTION-SCREEN shows the called program's screen first, so the user
" fills it in; USING SELECTION-SET runs a saved variant instead.
SUBMIT z_kw_select VIA SELECTION-SCREEN AND RETURN.
WRITE: / 'and back again'.
