# `TYPES` and `CONSTANTS` — naming a shape, naming a value

**Level:** 101 · newcomer

**One line:** `TYPES` gives a name to a shape so the shape is written once; `CONSTANTS` gives a name to a value so a literal is not repeated — and for internal tables the type carries a promise about lookup cost that you cannot change later without changing every declaration.

## A type is written once

```abap
TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.

TYPES: BEGIN OF ty_invoice,
         id       TYPE i,
         customer TYPE string,
         amount   TYPE ty_amount,
       END OF ty_invoice.
```

Change `ty_amount` to `DECIMALS 3` and every variable declared with it follows. Spell `p LENGTH 9 DECIMALS 2` out in nine places instead, and the day the requirement changes you will find eight of them.

The chained form — `TYPES:` with commas — is how a structure is written. The colon is not decoration: without it, every line would need its own `TYPES`.

## The table type is a decision, not a formality

```abap
TYPES ty_invoices  TYPE STANDARD TABLE OF ty_invoice WITH EMPTY KEY.
TYPES ty_by_id     TYPE SORTED   TABLE OF ty_invoice WITH UNIQUE KEY id.
TYPES ty_hashed_id TYPE HASHED   TABLE OF ty_invoice WITH UNIQUE KEY id.
```

Those three lines describe the same rows and three different data structures. Which one you name decides whether a lookup walks the table, halves it, or hashes straight to the row — and whether a duplicate is accepted, or comes back as `sy-subrc = 4`. [Internal tables](../../03_Topics/internal_tables/README.md) is the page that works through the trade.

`WITH EMPTY KEY` is worth a sentence of its own. It says, explicitly, *this table has no key* — which is honest, and which also means a bare `SORT itab.` sorts by nothing. Say `SORT itab BY field.` See [`SORT`](../sort/README.md).

## Where types live

A `TYPES` inside a program is visible only there. The moment two programs need the same shape, the type belongs somewhere both can see it: a class (`TYPES` in the `PUBLIC SECTION`), an interface, or the ABAP Dictionary. A DDIC type brings more than a shape — a label, an F1 help text, a check table, a conversion routine. See [DDIC, domains and data elements](../../03_Topics/ddic_and_domains/README.md).

## `CONSTANTS`

```abap
CONSTANTS lc_limit TYPE i VALUE 3.

CONSTANTS: BEGIN OF gc_status,
             open TYPE string VALUE `OPEN`,
             paid TYPE string VALUE `PAID`,
           END OF gc_status.
```

`VALUE` is mandatory and must be a literal — a constant cannot be computed at runtime. The structured form above is ABAP's traditional stand-in for an enumeration: `gc_status-open` reads better than `'OPEN'` and cannot be misspelled without the compiler noticing. Since 7.51 there is a real one; see [Enumerations](../enum/README.md).

`abap_true` and `abap_false` are constants of exactly this kind, living in the type pool `ABAP`. Write `IF lv_flag = abap_true.` rather than `IF lv_flag = 'X'.` — the two are the same character and only one of them says what it means.

<!-- snippet:z_kw_types -->
*[`z_kw_types.prog.abap`](snippets/z_kw_types.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
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
```
<!-- /snippet -->

## If you are coming from another language

- **C.** `TYPES` is `typedef`, and `BEGIN OF … END OF` is `struct`. The table kinds have no C equivalent — they are closer to choosing between a vector, a `std::map` and a `std::unordered_map` in one declaration.
- **Rust.** `type` aliases and `struct` cover the same ground; ABAP's table kinds correspond to `Vec`, `BTreeMap` and `HashMap`, except the choice is part of the type of the *table* rather than a different container.
- **Python.** `TypedDict` or a `dataclass` is the nearest shape; ABAP checks it at compile time.

## See also

- [`DATA` — and `DATA( )`](../data/README.md) — declaring the variables these types describe
- [Internal tables](../../03_Topics/internal_tables/README.md) — what each table kind actually costs
- [Enumerations](../enum/README.md) — the 7.51 replacement for a structured constant
- [DDIC, domains and data elements](../../03_Topics/ddic_and_domains/README.md) — types that carry their own labels and checks
- [`VALUE`](../value/README.md) — filling a structure of the type you just named
