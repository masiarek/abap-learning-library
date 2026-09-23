# Number ranges — the next document number

**Level:** 201 · working knowledge

**Status:** stub — the mechanism is here; the worked example is not yet.

**One line:** A number range object (`SNRO`) hands out sequential numbers through `NUMBER_GET_NEXT` — with **buffering** that makes the numbers fast and leaves gaps, and a **rollback that does not give a number back**, so "why are there holes in our invoice numbers" has an answer before anyone opens a ticket.

## The mechanism

```abap
CALL FUNCTION 'NUMBER_GET_NEXT'
  EXPORTING  nr_range_nr = '01'
             object      = 'ZINVOICE'
  IMPORTING  number      = lv_number
  EXCEPTIONS interval_not_found = 1 number_range_not_intern = 2
             object_not_found = 3 quantity_is_0 = 4 quantity_is_not_1 = 5
             interval_overflow = 6 buffer_overflow = 7 OTHERS = 8.
```

The object is defined once (`SNRO`), its intervals per client (`SNUM`, or the module's own transaction), and the function module is the only sanctioned way to take a number. Internal numbering hands the number out; external numbering checks one the user supplied.

## The two facts

- **Buffering.** With *main memory buffering*, each application server fetches a block of numbers (say 10) into memory and hands them out from there. Fast, and when the server restarts the unused rest of the block is gone. Gapless numbering means turning the buffer off (`SNRO` → no buffering) and accepting a database lock per number — which is what legally gapless documents, in some jurisdictions, require.
- **Not transactional.** A number taken and then rolled back stays taken. There is no "give it back", so an application that takes the number before it is sure it will post creates gaps by design. Take it as late as possible.

## What this page still needs

- [ ] a `snippets/` program taking a number from a demo object, once one exists to name
- [ ] the `SNRO` settings screen, with each buffering option's consequence recorded
- [ ] `NUMBER_GET_NEXT` with `quantity > 1`, and `NUMBER_CHECK`

## See also

- [`CALL FUNCTION`](../../02_Keywords/call_function/README.md) — the classic exception block above
- [LUW and locking](../luw_and_locking/README.md) — why a rollback does not return the number
- [`COMMIT WORK`](../../02_Keywords/commit_work/README.md) — what does not undo
- [How ABAP runs](../how_abap_runs/README.md) — per-server buffering
