# `EVENTS`, `RAISE EVENT`, `SET HANDLER` — objects that publish

**Level:** 301 · deep dive

**One line:** A class declares an event, raises it with `RAISE EVENT`, and any object whose method was registered with `SET HANDLER … FOR` is called — synchronously, in registration order — which decouples the raiser from its listeners and is how every GUI control and most frameworks in the system talk back to your code.

## The three parts

```abap
CLASS lcl_button DEFINITION.
  PUBLIC SECTION.
    EVENTS clicked EXPORTING VALUE(iv_times) TYPE i.   " 1. declare
    METHODS click.
ENDCLASS.
" inside click:  RAISE EVENT clicked EXPORTING iv_times = mv_times.   2. raise

CLASS lcl_logger DEFINITION.
  PUBLIC SECTION.
    METHODS on_clicked FOR EVENT clicked OF lcl_button IMPORTING iv_times.
ENDCLASS.
" SET HANDLER lo_logger->on_clicked FOR lo_button.                     3. subscribe
```

The handler's parameters are a subset of the event's, by name, plus the implicit `sender`. `FOR ALL INSTANCES` subscribes to every object of the class; `ACTIVATION abap_false` unsubscribes. `CLASS-EVENTS` are static and need no instance.

## What to know before relying on it

- **Synchronous.** `RAISE EVENT` returns after every handler has run. A slow handler slows the raiser; an exception in a handler propagates into the raiser.
- **No handler, no error.** An event nobody subscribed to is a no-op — which is the decoupling, and also why a missing `SET HANDLER` fails silently.
- **Lifetime.** A registration holds a reference to the handler object, so a handler registered and forgotten keeps that object alive.
- **The classic use is the GUI.** `cl_gui_alv_grid`'s `double_click`, `toolbar` and `user_command` are events; so are the frame's `close` and every control's `data_changed`. Any non-trivial dynpro program is mostly handlers.

Where the raiser and the listener are both your own classes, an interface method call is usually clearer than an event. Events earn their place when the raiser must not know who is listening.

<!-- snippet:z_kw_events -->
*[`z_kw_events.prog.abap`](snippets/z_kw_events.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_kw_events.

CLASS lcl_button DEFINITION.
  PUBLIC SECTION.
    EVENTS clicked EXPORTING VALUE(iv_times) TYPE i.
    METHODS click.
  PRIVATE SECTION.
    DATA mv_times TYPE i.
ENDCLASS.

CLASS lcl_button IMPLEMENTATION.
  METHOD click.
    mv_times = mv_times + 1.
    " Raising the event runs every registered handler, synchronously, before
    " the next statement here. No handler registered: no effect, no error.
    RAISE EVENT clicked EXPORTING iv_times = mv_times.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_logger DEFINITION.
  PUBLIC SECTION.
    " A handler names the event and the class it belongs to. Its parameters
    " are a subset of the event's, with the same names.
    METHODS on_clicked FOR EVENT clicked OF lcl_button
      IMPORTING iv_times.
ENDCLASS.

CLASS lcl_logger IMPLEMENTATION.
  METHOD on_clicked.
    WRITE: / 'clicked', iv_times, 'time(s)'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA(lo_button) = NEW lcl_button( ).
  DATA(lo_logger) = NEW lcl_logger( ).

  lo_button->click( ).                 " nobody is listening yet

  SET HANDLER lo_logger->on_clicked FOR lo_button.
  lo_button->click( ).
  lo_button->click( ).

  " Registration is per handler and per object; ACTIVATION abap_false undoes it.
  SET HANDLER lo_logger->on_clicked FOR lo_button ACTIVATION abap_false.
  lo_button->click( ).                 " silent again
  WRITE: / 'done'.
```
<!-- /snippet -->

## If you are coming from another language

- **C#.** `event`/`delegate` with `+=` is the closest match, including the synchronous delivery.
- **JavaScript.** `addEventListener`, minus the asynchronous event loop — ABAP delivers on the spot.
- **Python.** No language feature; the observer pattern written by hand, which is also what ABAP's is under the hood.

## See also

- [`CLASS`](../class/README.md) — where events are declared
- [`METHODS` and parameters](../methods/README.md) — the handler signature
- [ALV](../../03_Topics/alv/README.md) — the events you will actually handle first
- [Dynpro screens](../../03_Topics/dynpro_screens/README.md) — GUI controls and their events
- [Object-oriented ABAP](../../03_Topics/oo_abap/README.md) — when an event beats an interface call
