# `CORRESPONDING` and `MOVE-CORRESPONDING` — copy by name

**Level:** 201 · working knowledge

**One line:** Both copy components whose names match, but `MOVE-CORRESPONDING` writes into a structure that already exists and leaves everything else in it alone, while `CORRESPONDING #( )` builds a *new* value in which everything not copied comes back initial — and that difference silently loses a field in real code.

## The difference, in four lines

```abap
DATA ls_kept TYPE ty_target.
ls_kept-country = `UK`.
MOVE-CORRESPONDING ls_src TO ls_kept.        " country is still `UK`

DATA(ls_fresh) = CORRESPONDING ty_target( ls_src ).   " country is initial
```

`MOVE-CORRESPONDING` is a statement operating on a target that exists. `CORRESPONDING` is an expression producing a value from nothing. Neither is wrong; using the second where the first was meant is how a country code, a currency or a status disappears from a structure that "was only being mapped".

`BASE` is how the keep-what-was-there behaviour comes back inside an expression:

```abap
DATA(ls_based) = CORRESPONDING ty_target( BASE ( ls_existing ) ls_src ).
```

## `MAPPING` and `EXCEPT`

Names that do not match are not copied. When the names *should* correspond but do not, say so:

```abap
DATA(ls_mapped) = CORRESPONDING ty_target( ls_src MAPPING country = city ).
DATA(ls_except) = CORRESPONDING ty_target( ls_src EXCEPT name ).
```

`MAPPING target = source`, in that order. `EXCEPT` drops a component that would otherwise have been copied; `EXCEPT *` drops everything not named in `MAPPING`, which is the explicit form worth preferring when the structures are large and the mapping is the point.

## Why both still exist

`MOVE-CORRESPONDING` has been in ABAP since long before expressions, and it does one thing the expression cannot: it works on deeply nested structures with the `EXPANDING NESTED TABLES` addition, and it reads naturally as a statement in code that is already statement-shaped. It is **not** obsolete, and [Clean ABAP](../../03_Topics/clean_abap/README.md) does not ask you to remove it.

What both share is the real danger: **a component that is not copied is not reported**. Rename a field in one structure and the copy silently stops moving it. Nothing in ABAP warns. Where the mapping matters — an interface, a conversion, anything crossing a system boundary — writing the assignments out is not old-fashioned, it is the version that breaks loudly when a name changes.

<!-- snippet:z_kw_corresponding -->
*[`z_kw_corresponding.prog.abap`](snippets/z_kw_corresponding.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_corresponding.

TYPES: BEGIN OF ty_source,
         id   TYPE i,
         name TYPE string,
         city TYPE string,
       END OF ty_source.

TYPES: BEGIN OF ty_target,
         id      TYPE i,
         name    TYPE string,
         country TYPE string,
       END OF ty_target.

DATA(ls_src) = VALUE ty_source( id = 1 name = `Ada` city = `London` ).

" MOVE-CORRESPONDING writes into a structure that already exists, and leaves
" every component it has nothing to say about untouched: country survives.
DATA ls_kept TYPE ty_target.
ls_kept-country = `UK`.
MOVE-CORRESPONDING ls_src TO ls_kept.

" CORRESPONDING #( ) builds a NEW value. Nothing survives, because nothing was
" there: country comes back initial. This is the difference that bites.
DATA(ls_fresh) = CORRESPONDING ty_target( ls_src ).

" BASE is how the keep-what-was-there behaviour comes back, as an expression.
DATA(ls_based) = CORRESPONDING ty_target( BASE ( VALUE ty_target( country = `UK` ) )
                                          ls_src ).

" Names that do not match are not moved -- unless MAPPING says they are.
DATA(ls_mapped) = CORRESPONDING ty_target( ls_src MAPPING country = city ).

" EXCEPT drops a component that would otherwise have been copied.
DATA(ls_except) = CORRESPONDING ty_target( ls_src EXCEPT name ).

WRITE: / 'kept   ', ls_kept-name,   ls_kept-country.
WRITE: / 'fresh  ', ls_fresh-name,  ls_fresh-country.
WRITE: / 'based  ', ls_based-name,  ls_based-country.
WRITE: / 'mapped ', ls_mapped-name, ls_mapped-country.
WRITE: / 'except ', ls_except-name, ls_except-country.
```
<!-- /snippet -->

## If you are coming from another language

- **Python.** `dict.update()` is `MOVE-CORRESPONDING`; building a fresh dict from a comprehension is `CORRESPONDING`. Python's version fails just as silently on a renamed key.
- **JavaScript.** `Object.assign(target, src)` versus `{...src}`, in exactly that pairing.
- **Rust.** There is no by-name copy: a `From` implementation lists the fields, and adding a field to the struct breaks the conversion until you handle it. That is the trade — more typing, no silent loss.

## See also

- [`VALUE`](../value/README.md) — the same `BASE` idea, for building values from scratch
- [`TYPES` and `CONSTANTS`](../types/README.md) — the structures whose names have to match
- [Clean ABAP](../../03_Topics/clean_abap/README.md) — where explicit assignment beats clever copying
- [BAPIs and RFC](../../03_Topics/bapis_and_rfc/README.md) — the interfaces where a silently dropped field costs most
- [Constructor expressions](../../03_Topics/constructor_expressions/README.md) — the `VALUE`/`NEW`/`COND` family as a family
