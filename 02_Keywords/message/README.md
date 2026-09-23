# `MESSAGE` — six types, six different things that happen next

**Level:** 201 · working knowledge

**One line:** `MESSAGE` displays a message from a message class, and the single-letter **type** decides whether the program carries on, stops the step, or dies — with `W` and `E` behaving differently in the background than on a screen, which is the trap.

## The types

| Type | On a screen | In a background job |
|---|---|---|
| `S` | status line, next screen; program continues | written to the job log, continues |
| `I` | dialog box, then continues | **cannot be displayed** — behaves like a hard stop |
| `W` | warning, user may continue | behaves like `E` |
| `E` | error, the step stops and waits for input | ends the job step |
| `A` | abend — the transaction ends | ends the job |
| `X` | deliberate short dump, with a dump analysis | short dump |

The difference between a report that works for a user and one that hangs a nightly job is often a single `I` in a branch nobody tested in the background. Check `sy-batch` where it matters, or use `MESSAGE … INTO` and let the caller decide.

## Where the text comes from

```abap
MESSAGE e001(zfin) WITH lv_doc lv_year.
```

`zfin` is a message class (`SE91`), `001` the number, and `&1 &2 &3 &4` in the stored text are filled by `WITH`. Message classes exist so the text is **translatable** and **findable**: a support case quoting `ZFIN 001` can be looked up; one quoting an English sentence typed into a program cannot.

The literal form — `MESSAGE 'Quantity is zero' TYPE 'S'.` — needs no message class and cannot be translated. It is fine in a throwaway, and it is the wrong thing to ship.

## Capturing instead of displaying

```abap
MESSAGE e001(zfin) WITH lv_doc INTO DATA(lv_text).
```

`INTO` builds the text and displays nothing, leaving `sy-msgid`, `sy-msgno`, `sy-msgty` and `sy-msgv1…4` set. This is the form to use in a class: a method that *displays* something has decided it is running on a screen, and it will be wrong the first time it runs in an RFC, a job, or an OData handler.

This is also exactly how a BAPI reports problems — its `RETURN` table is `BAPIRET2` rows holding those same fields. See [BAPIs and RFC](../../03_Topics/bapis_and_rfc/README.md).

## `RAISING` — the bridge to exceptions

```abap
MESSAGE e001(zfin) RAISING not_found.
```

Inside a function module, this raises the classic exception `not_found` **and** leaves the message in the `sy-msg…` fields, so the caller can both branch on `sy-subrc` and show the text. It is the seam between the two error mechanisms, and the reason so much SAP code moves messages around in variables.

<!-- snippet:z_kw_message -->
*[`z_kw_message.prog.abap`](snippets/z_kw_message.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_message.

PARAMETERS p_qty TYPE i DEFAULT 0.

START-OF-SELECTION.

  " The literal form: a text, a type, no message class needed. Fine for a
  " throwaway; it cannot be translated, so it does not belong in shipped code.
  IF p_qty = 0.
    MESSAGE 'Quantity is zero' TYPE 'S'.
  ENDIF.

  " sy-msgid, sy-msgno and sy-msgv1..4 hold the last message raised. A BAPI
  " hands its problems back in exactly these pieces, inside its RETURN table.
  WRITE: / 'last message type', sy-msgty.

  " Capturing a message instead of displaying it -- MESSAGE ... INTO -- needs a
  " message from a message class, not a text literal. That form is on the page;
  " it is left out here because this program would then need a message class
  " that your system does not have.

  " The type is not cosmetic: it decides what happens next.
  "   'S' status line, program continues      'I' dialog box, then continues
  "   'W' warning, behaves like E in batch    'E' error, stops the step
  "   'A' abend, ends the transaction         'X' short dump on purpose
  IF p_qty < 0.
    MESSAGE 'Quantity cannot be negative' TYPE 'E'.
  ENDIF.

  WRITE: / 'quantity accepted:', p_qty.
```
<!-- /snippet -->

## If you are coming from another language

- **Anywhere with logging.** The closest analogue is a log level, except that here the level also controls **control flow**. `E` is not "log an error", it is "stop".
- **Python / Java.** Raising an exception is `MESSAGE … RAISING` or a class-based exception; printing is `S`. Mixing the two roles in one statement is the ABAP peculiarity.

## See also

- [`TRY`, `CATCH`, `RAISE`](../try_catch/README.md) — the mechanism to prefer inside classes
- [BAPIs and RFC](../../03_Topics/bapis_and_rfc/README.md) — `BAPIRET2`, and why it looks like `sy-msg…`
- [Background jobs](../../03_Topics/background_jobs/README.md) — what happens to each message type when nobody is watching
- [`ASSERT`](../assert/README.md) — for a condition that is a bug rather than a message
- [System fields](../sy_fields/README.md) — `sy-subrc`, `sy-tabix`, `sy-index` and the rest
- [Application log](../../03_Topics/application_log/README.md) — messages that outlive the run
- [Text elements and translation](../../03_Topics/text_elements_and_translation/README.md) — nothing a user reads belongs in a literal
