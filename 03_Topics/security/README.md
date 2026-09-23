# Security — the ABAP-specific holes

**Level:** 301 · deep dive

**Status:** stub — the checklist is here; the worked examples are not yet.

**One line:** Beyond missing [authorization checks](../authorizations/README.md), ABAP has a handful of injection surfaces of its own — dynamic Open SQL built from input, native SQL, dynamic program generation, directory traversal in file paths, and `CALL TRANSACTION` without a check — each with a released API or an escaping function that closes it, and an ATC security check that finds it.

## The checklist

| Surface | Vulnerable form | Safe form |
|---|---|---|
| Dynamic `WHERE` | `SELECT … WHERE (lv_where)` with `lv_where` built from input | `cl_abap_dyn_prg=>escape_quotes( )`, `check_whitelist_str( )`, or no dynamic `WHERE` at all |
| Dynamic table / column names | `FROM (lv_table)` from input | check against a whitelist (`check_table_name_str`) |
| Native SQL | a statement string with input in it | ADBC with bound parameters |
| Code generation | `GENERATE SUBROUTINE POOL`, `INSERT REPORT` from input | do not; if unavoidable, `cl_abap_dyn_prg` escaping and a security review |
| File paths | `OPEN DATASET lv_path` with `../` from input | logical file names (`FILE_VALIDATE_NAME`), `cl_fs_path` |
| Transaction calls | `CALL TRANSACTION` (no check by default since 7.40) | `WITH AUTHORITY-CHECK`, or `AUTHORITY_CHECK_TCODE` |
| RFC | remote-enabled function modules with no authorization check inside | check inside the module; `S_RFC` is not enough |
| Web output (BSP, custom HTTP) | unescaped input in HTML | `escape( val = … format = cl_abap_format=>e_html_text )` |
| Hard-coded credentials | passwords in source, in `Z` tables | secure store (`SECSTORE`), destinations |
| Debugging in production | `S_DEVELOP` with debug and *replace* | a role question, but the developer is the one who asks |

The ATC's security checks (from the Code Vulnerability Analyzer, licensed separately, or the basic checks included) flag most of the left column. Run them.

## Why it earns a page

Because Open SQL's `@` escaping made injection *rare* in ABAP and so nobody expects the dynamic forms to be different; because a `Z` report with a dynamic `WHERE` built from a `PARAMETERS` field is a common convenience; and because an RFC-enabled module is callable from *outside* the system by anyone with an RFC user, whatever transaction they cannot run.

## What this page still needs

- [ ] each row demonstrated in a `snippets/` program, vulnerable and safe side by side
- [ ] the ATC security finding for each, recorded
- [ ] `cl_abap_dyn_prg` in full, since it is the class most of the fixes use

## See also

- [Authorizations](../authorizations/README.md) — the first check
- [Dynamic programming](../dynamic_programming/README.md) — where the surfaces come from
- [Native SQL](../native_sql/README.md) — the second surface
- [`CALL TRANSACTION`](../../02_Keywords/call_transaction/README.md) — the default that changed
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the checks
