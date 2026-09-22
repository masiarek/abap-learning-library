# Exceptions — designing the failure, not just catching it

**Level:** 201 · working knowledge

**Status:** stub — the design questions are here; the worked example is not yet.

**One line:** ABAP has three error mechanisms in active use — class-based exceptions, classic function-module exceptions, and `MESSAGE` types that end a step — and most bad error handling in a system comes from translating between them badly rather than from any one of them.

## The three, and where each comes from

| Mechanism | Raised by | Reported as |
|---|---|---|
| Class-based (`cx_…`) | `RAISE EXCEPTION`, modern APIs | an object, caught with `TRY … CATCH` |
| Classic | function modules | a number you assign, read from `sy-subrc` |
| `MESSAGE` | anything, anywhere | a screen message that may also end the step |

Code that calls a BAPI, wraps it in a class, and is itself called from an OData handler has to move an error across all three. Each translation is a chance to lose the details — which document, which row, which value — and the usual symptom is a log full of "Error occurred".

## The design questions

- **Which flavour?** `CX_STATIC_CHECK` forces every caller to deal with it; `CX_DYNAMIC_CHECK` does not; `CX_NO_CHECK` propagates to the top. The choice is about your API's contract, not about the failure's severity. See [`TRY`, `CATCH`, `RAISE`](../../02_Keywords/try_catch/README.md).
- **What does the exception carry?** Typed attributes — the document number, the amount, the row index — can be tested and displayed. A pre-formatted message string can only be printed.
- **Wrap or propagate?** `PREVIOUS` chains an exception to its cause, so a wrapper can add context without discarding the original. A `CATCH` that raises a new exception and drops `PREVIOUS` throws away the stack trace.
- **Where is the boundary?** Exactly one layer should turn an exception into something a user sees. Everywhere else it should keep travelling.

## What this page still needs

- [ ] a custom exception class with `PREVIOUS`, a text from a message class, and `get_text( )` worked through
- [ ] `RESUMABLE` exceptions and `RETRY` / `RESUME`, which almost nobody uses and occasionally should
- [ ] a BAPI `RETURN` table converted into a class-based exception, as a reusable pattern
- [ ] what a short dump in `ST22` shows, and how to read it back to the raising line

## See also

- [`TRY`, `CATCH`, `RAISE`](../../02_Keywords/try_catch/README.md) — the syntax, with a program
- [`MESSAGE`](../../02_Keywords/message/README.md) — the mechanism that ends a step instead of raising
- [`CALL FUNCTION`](../../02_Keywords/call_function/README.md) — classic exceptions and `sy-subrc`
- [`ASSERT`](../../02_Keywords/assert/README.md) — for what should be impossible
- [BAPIs and RFC](../bapis_and_rfc/README.md) — `BAPIRET2`, the most common error shape in SAP
