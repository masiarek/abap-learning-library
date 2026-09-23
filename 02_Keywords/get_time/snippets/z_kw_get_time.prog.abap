REPORT z_kw_get_time.

" sy-datum and sy-uzeit are set when the program starts and refreshed only by
" GET TIME. A job that prints sy-uzeit at the end prints its START time
" unless something asked again in between.
WRITE: / 'at start ', sy-uzeit.
GET TIME.
WRITE: / 'refreshed', sy-uzeit.

" GET RUN TIME FIELD: microseconds since the first call in this program. The
" cheapest way to time a block -- and a measurement, which beats a guess.
DATA lv_t0 TYPE i.
DATA lv_t1 TYPE i.
DATA lv_sum TYPE i.
GET RUN TIME FIELD lv_t0.
DO 100000 TIMES.
  lv_sum = lv_sum + sy-index.
ENDDO.
GET RUN TIME FIELD lv_t1.
DATA(lv_took) = lv_t1 - lv_t0.
WRITE: / 'loop took (microseconds)', lv_took.

" A time stamp is wall-clock time in UTC, independent of who is logged on and
" from where. See the dates and times topic for turning it back into a date.
GET TIME STAMP FIELD DATA(lv_stamp).
WRITE: / 'utc time stamp', lv_stamp.

" WAIT UP TO releases the work process rather than spinning -- and it also
" ends the database LUW with an implicit commit, which is the fact to know.
WAIT UP TO 1 SECONDS.
GET TIME.
WRITE: / 'after wait', sy-uzeit.
