# ABAP Unit — tests that ship with the program

**Level:** 201 · working knowledge

**One line:** ABAP Unit is xUnit built into the language: a local class marked `FOR TESTING` lives in the same source as the code it tests, is invisible in production, and runs from ADT or `SE38` — and the hard part is never the framework, it is that untestable code has to be reshaped before a test can reach it.

## The shape

```abap
CLASS ltcl_invoice DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO lcl_invoice.
    METHODS setup.
    METHODS zero_rate_changes_nothing FOR TESTING.
ENDCLASS.
```

`setup` runs before **every** test method, so no test inherits another's state; `teardown` after each; `class_setup`/`class_teardown` once for the whole class. `RISK LEVEL HARMLESS` means the test changes no persistent data — and a system can be configured to refuse to run anything riskier, which is why the declaration is not decoration.

Assertions come from `cl_abap_unit_assert`: `assert_equals`, `assert_initial`, `assert_bound`, `assert_true`, `fail`. Each takes a `msg` — write it as the sentence a colleague reads when the test fails at 3 a.m., not as the method name repeated.

## The part that is actually hard

A test can only reach code it can call. That rules out:

- A `FORM` in a report — not callable from anywhere else. See [`FORM` and `PERFORM`](../../02_Keywords/perform_form/README.md).
- Logic inside `START-OF-SELECTION`, mixed with `SELECT` and `WRITE`.
- A method that reads the database itself, unless you are willing to run a test against real data — which `RISK LEVEL` is there to stop you doing casually.

The way out is the same in ABAP as anywhere: separate deciding from fetching. The calculation takes data as parameters and returns a result; a separate class does the `SELECT`. The test then feeds the calculation a table it built by hand, which is why [interfaces](../../02_Keywords/interfaces/README.md) and test doubles keep appearing in this conversation.

Test seams in ABAP come in three grades: an **interface** the test implements itself, a **test double framework** (`cl_abap_testdouble` for classes, the CDS and OSQL test doubles for database access), and `PRIVATE SECTION` visibility relaxed for tests by declaring the test class a `FRIENDS` of the class under test — the last of which is handy and, used as a habit, becomes a way to test the implementation instead of the behaviour.

<!-- snippet:z_tp_abap_unit -->
*[`z_tp_abap_unit.prog.abap`](snippets/z_tp_abap_unit.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_abap_unit.

" The code under test. It is a class, and that is not incidental: a FORM or a
" chunk of START-OF-SELECTION cannot be called by a test.
CLASS lcl_invoice DEFINITION.
  PUBLIC SECTION.
    TYPES ty_amount TYPE p LENGTH 9 DECIMALS 2.
    METHODS net_of_tax IMPORTING iv_gross      TYPE ty_amount
                                 iv_rate       TYPE ty_amount
                       RETURNING VALUE(rv_net) TYPE ty_amount.
ENDCLASS.

CLASS lcl_invoice IMPLEMENTATION.
  METHOD net_of_tax.
    rv_net = iv_gross / ( 1 + iv_rate / 100 ).
  ENDMETHOD.
ENDCLASS.

" The test class. FOR TESTING makes it invisible outside a unit test run, so it
" ships with the program and costs nothing in production.
CLASS ltcl_invoice DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO lcl_invoice.   " cut: code under test
    METHODS setup.
    METHODS zero_rate_changes_nothing FOR TESTING.
    METHODS twenty_percent            FOR TESTING.
ENDCLASS.

CLASS ltcl_invoice IMPLEMENTATION.
  METHOD setup.
    " Runs before EVERY test method, so no test inherits another test's state.
    mo_cut = NEW lcl_invoice( ).
  ENDMETHOD.

  METHOD zero_rate_changes_nothing.
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->net_of_tax( iv_gross = '100.00' iv_rate = 0 )
      exp = CONV lcl_invoice=>ty_amount( '100.00' )
      msg = 'A zero tax rate must leave the gross amount alone' ).
  ENDMETHOD.

  METHOD twenty_percent.
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->net_of_tax( iv_gross = '120.00' iv_rate = 20 )
      exp = CONV lcl_invoice=>ty_amount( '100.00' )
      msg = '120 gross at 20 percent is 100 net' ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  WRITE: / 'Run the tests with Ctrl+Shift+F10 in ADT, or SE38 -> Execute -> Unit Test.'.
```
<!-- /snippet -->

## If you are coming from another language

- **Java / C#.** JUnit and NUnit map almost one to one, including `setup`/`teardown`. The differences: tests live in the *same* source unit rather than a parallel tree, and `RISK LEVEL` has no equivalent because no other language assumes the test might change production data.
- **Python.** `unittest` is the closer relative than `pytest` — classes, `setUp`, explicit assertion methods.
- **Rust.** `#[cfg(test)] mod tests` beside the code is the same idea as a local test class in the same program, for the same reason: the test can see what the module can.

## See also

- [`CLASS`](../../02_Keywords/class/README.md) — local classes, and the factory that makes doubling possible
- [`INTERFACE` and `INTERFACES`](../../02_Keywords/interfaces/README.md) — the seam a test needs
- [Object-oriented ABAP](../oo_abap/README.md) — why testability and OO are one argument
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the other automated check on your transport
- [Clean ABAP](../clean_abap/README.md) — the style guide that assumes tests exist
