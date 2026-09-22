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
