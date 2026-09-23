# Modularization — includes, subroutines, function modules, classes

**Level:** 201 · working knowledge

**Status:** stub — the comparison is here; the worked example is not yet.

**One line:** ABAP accumulated four ways to split code up and never removed any of them — `INCLUDE`, `FORM`, function module, class — and the only one to choose for new work is the class, with the others remaining as things you must read and occasionally extend.

## The four, and what each really is

| Unit | Really is | Still right for |
|---|---|---|
| `INCLUDE` | textual insertion at compile time | the generated structure of a module pool; nothing new |
| `FORM` / `PERFORM` | a subroutine sharing the program's globals | reading old code; classic exits |
| Function module | a globally callable unit in a function group, with a typed interface | RFC, BAPIs, update-task calls, dynamic calls |
| Class / method | encapsulation, state, interfaces, tests | everything else |

A function group's global data is shared by all its modules and survives between calls in a session — which is the mechanism behind many "buffered" SAP function modules, and a hazard when it is not intentional.

`INCLUDE` deserves a warning of its own: it is textual, so the included code sees the including program's variables and vice versa. A variable declared in one include and used in another compiles, and nothing tells you where anything came from.

## The one test that decides

Can this unit be called by a test, with data the test constructs? A method on a class: yes. A function module: yes, with care. A `FORM` in a report: no. That answer, not taste, is why [ABAP Unit](../abap_unit/README.md) and modularization are the same subject.

## What this page still needs

- [ ] a worked conversion: one report's `FORM`s into a local class, with the tests that follow
- [ ] function group global data demonstrated, including the buffering surprise
- [ ] when a *global* class beats a local one, and the naming/package consequences
- [ ] where RAP behaviour implementations fit in this list

## See also

- [`FORM` and `PERFORM`](../../02_Keywords/perform_form/README.md) — the obsolete unit, read fluently
- [`CALL FUNCTION`](../../02_Keywords/call_function/README.md) — calling a function module
- [`CLASS`](../../02_Keywords/class/README.md) — the one to write
- [ABAP Unit](../abap_unit/README.md) — the test that decides
- [Transports](../transports/README.md) — packages, and what travels together
- [Program types](../program_types/README.md) — executable, module pool, function group, class pool
- [Packages and namespaces](../packages_and_namespaces/README.md) — where an object lives, and who may use it
- [`STATICS`](../../02_Keywords/statics/README.md) — a local variable that survives between calls
