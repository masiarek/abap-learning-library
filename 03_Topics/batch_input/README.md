# Batch input and BDC — driving a transaction as if you were typing

**Level:** 201 · working knowledge

**Status:** stub — the mechanism is here; the worked example is not yet.

**One line:** Batch Data Communication fills a table of screen-field-value rows (`BDCDATA`) and replays it through a transaction with `CALL TRANSACTION … USING` or a session (`BDC_OPEN_GROUP`, `SM35`) — the pre-BAPI way to post data through the standard screens, still the only way for some transactions, and broken by every screen change.

## The mechanism

1. Record the transaction once in `SHDB`: every screen, every field, every OK code.
2. Turn the recording into a `BDCDATA` table in code, replacing the recorded values with your data.
3. Replay it: `CALL TRANSACTION 'VA01' USING lt_bdc MODE 'N' UPDATE 'S' MESSAGES INTO lt_msg.` for direct execution, or `BDC_INSERT` into a session that a user processes in `SM35`.
4. Read the messages: the same `BDCMSGCOLL` shape as `sy-msg…`, one row per screen message.

`MODE 'A'` shows every screen (debugging), `'E'` stops at errors, `'N'` runs invisibly. `UPDATE 'S'` waits for the update task, which is the only way to know the posting succeeded before the next one starts.

## Why it is still here

Every legacy data migration was done this way, `LSMW` is a front end for it, and transactions without a BAPI still need it. Its fragility is structural — a field moved to a different tab in a support package breaks the recording silently — which is why a BAPI, when one exists, wins every time.

## What this page still needs

- [ ] a `BDCDATA` table for a demo transaction, built in a `snippets/` program
- [ ] `SHDB` and the generated program, annotated
- [ ] a session in `SM35` with an error, recorded, and how it is corrected
- [ ] `LSMW` in one paragraph, and where migration goes now (the Migration Cockpit)

## See also

- [`CALL TRANSACTION`](../../02_Keywords/call_transaction/README.md) — the `USING` form
- [Dynpro screens](../dynpro_screens/README.md) — what is being driven
- [BAPIs and RFC](../bapis_and_rfc/README.md) — the alternative to prefer
- [`MESSAGE`](../../02_Keywords/message/README.md) — the message shape that comes back
