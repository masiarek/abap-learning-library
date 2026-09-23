# Test doubles — replacing the database, the class, the function module

**Level:** 301 · deep dive

**Status:** stub — the map is here; the worked examples are not yet.

**One line:** A unit test that reads the real database is an integration test with a slow, unrepeatable fixture; ABAP has four ways to replace a dependency — your own class implementing an interface, `cl_abap_testdouble` for a class you do not want to hand-write, the CDS and Open SQL test double frameworks for the database, and the function-module test double — and choosing one starts with a seam the code under test has to have.

## The four

| Dependency | Double | Needs |
|---|---|---|
| A class you call | a local class implementing the same interface; or `cl_abap_testdouble=>create( 'ZIF_X' )` with configured calls | the dependency reached through an **interface**, injected |
| A database read (`SELECT`) | `cl_osql_test_environment=>create( VALUE #( ( 'SFLIGHT' ) ) )`, then `insert_test_data( )` | 7.52+; the code under test unchanged |
| A CDS view | `cl_cds_test_environment=>create( 'ZI_FLIGHTS' )` with test data for the underlying tables | 7.51+ |
| A function module | `cl_function_test_environment=>create( VALUE #( ( 'BAPI_X' ) ) )` and configured outputs | 7.53+ |
| Authorization checks | `cl_aunit_authority_check` / the authority test double | 7.55+ |

The first row is the one that shapes the code: a class that `NEW`s its own collaborator inside a method has no seam, and no framework can reach in. Constructor injection with a default — `IMPORTING io_reader TYPE REF TO zif_reader OPTIONAL` — is the smallest change that creates one.

## Why it earns a page

Because "we cannot unit test, it needs the database" is the sentence that keeps ABAP tests from being written, and the OSQL test double removes the excuse for the read side: the test inserts three rows into a redirected `SFLIGHT`, the code under test selects from it, nothing touches the real table. What is left is design — the seams — which is [ABAP Unit](../abap_unit/README.md)'s real subject.

## What this page still needs

- [ ] a `snippets/` test class using the OSQL test double against `SFLIGHT`
- [ ] the same dependency doubled by hand and by `cl_abap_testdouble`, side by side
- [ ] the release table above verified against the keyword documentation

## See also

- [ABAP Unit](../abap_unit/README.md) — the framework
- [`INTERFACE` and `INTERFACES`](../../02_Keywords/interfaces/README.md) — the seam
- [`CLASS`](../../02_Keywords/class/README.md) — the factory and constructor injection
- [Open SQL](../open_sql/README.md) — what is being redirected
