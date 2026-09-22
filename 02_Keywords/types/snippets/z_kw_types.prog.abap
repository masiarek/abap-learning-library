REPORT z_kw_types.

" A named type is written once and referred to everywhere else. Change the
" length here and every variable declared TYPE ty_amount follows.
TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.

TYPES: BEGIN OF ty_invoice,
         id       TYPE i,
         customer TYPE string,
         amount   TYPE ty_amount,
       END OF ty_invoice.

" The same row type, three table kinds. The kind is a promise about lookup
" cost and about duplicates, not decoration.
TYPES ty_invoices  TYPE STANDARD TABLE OF ty_invoice WITH EMPTY KEY.
TYPES ty_by_id     TYPE SORTED   TABLE OF ty_invoice WITH UNIQUE KEY id.
TYPES ty_hashed_id TYPE HASHED   TABLE OF ty_invoice WITH UNIQUE KEY id.

CONSTANTS: BEGIN OF gc_status,
             open TYPE string VALUE `OPEN`,
             paid TYPE string VALUE `PAID`,
           END OF gc_status.

DATA lt_invoices TYPE ty_invoices.
DATA lt_by_id    TYPE ty_by_id.

DATA(ls_invoice) = VALUE ty_invoice( id = 1 customer = `Ada` amount = '199.95' ).
APPEND ls_invoice TO lt_invoices.
INSERT ls_invoice INTO TABLE lt_by_id.

WRITE: / ls_invoice-id, ls_invoice-customer, ls_invoice-amount, gc_status-open.
