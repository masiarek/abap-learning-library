REPORT z_kw_class.

INTERFACE lif_greeter.
  METHODS greet IMPORTING iv_name        TYPE string
                RETURNING VALUE(rv_text) TYPE string.
ENDINTERFACE.

CLASS lcl_plain DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_greeter.
    " A factory method instead of a public constructor: the class decides how
    " it is built, and the caller is not tied to the class name forever.
    CLASS-METHODS create RETURNING VALUE(ro_greeter) TYPE REF TO lif_greeter.
    CLASS-DATA gv_created TYPE i READ-ONLY.
  PROTECTED SECTION.
    METHODS salutation RETURNING VALUE(rv_word) TYPE string.
ENDCLASS.

CLASS lcl_plain IMPLEMENTATION.
  METHOD create.
    ro_greeter = NEW lcl_plain( ).
    gv_created = gv_created + 1.
  ENDMETHOD.
  METHOD salutation.
    rv_word = `Hello`.
  ENDMETHOD.
  METHOD lif_greeter~greet.
    rv_text = |{ salutation( ) }, { iv_name }!|.
  ENDMETHOD.
ENDCLASS.

" Inheritance: only the difference is written down. REDEFINITION needs the
" method to be non-final in the superclass, and PROTECTED is what makes it
" visible here at all.
CLASS lcl_loud DEFINITION INHERITING FROM lcl_plain.
  PROTECTED SECTION.
    METHODS salutation REDEFINITION.
ENDCLASS.

CLASS lcl_loud IMPLEMENTATION.
  METHOD salutation.
    rv_word = |{ super->salutation( ) CASE = UPPER }|.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  " Both objects are used through the interface, so the code below does not
  " know or care which class it got.
  DATA lt_greeters TYPE STANDARD TABLE OF REF TO lif_greeter WITH EMPTY KEY.
  APPEND lcl_plain=>create( ) TO lt_greeters.
  APPEND NEW lcl_loud( ) TO lt_greeters.

  LOOP AT lt_greeters INTO DATA(lo_greeter).
    WRITE: / lo_greeter->greet( `Ada` ).
  ENDLOOP.

  WRITE: / 'objects made by the factory:', lcl_plain=>gv_created.
