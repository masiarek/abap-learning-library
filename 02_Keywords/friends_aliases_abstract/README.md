# `FRIENDS`, `ALIASES`, `ABSTRACT`, `FINAL` — the class additions

**Level:** 301 · deep dive

**Status:** stub — the table is here; the worked program is not yet.

**One line:** Four additions to a class definition that each change who may do what: `ABSTRACT` forbids instantiation and allows methods without bodies, `FINAL` forbids inheritance, `FRIENDS` opens the private section to named classes, and `ALIASES` gives an interface method a short name — with `FRIENDS` being the one that quietly turns a unit test into a test of the implementation.

## The table

| Addition | On | Means |
|---|---|---|
| `CLASS … DEFINITION ABSTRACT.` | class | cannot be instantiated; may declare `METHODS m ABSTRACT.` with no implementation |
| `CLASS … DEFINITION FINAL.` | class | no subclass may be declared; all methods are implicitly final |
| `METHODS m FINAL.` | method | this method may not be redefined |
| `CLASS … DEFINITION FRIENDS zcl_other ltcl_test.` | class | the named classes see the private and protected sections |
| `CLASS … DEFINITION LOCAL FRIENDS zcl_x.` | test include | the local test class is a friend of the global class |
| `ALIASES short FOR lif_x~long.` | class | `short( )` calls `lif_x~long( )` |
| `CLASS … DEFINITION CREATE PRIVATE.` | class | only the class itself (a factory) may instantiate it |
| `CLASS … DEFINITION DEFERRED.` / `LOAD` | program | forward declaration for local classes |

`ABSTRACT` plus `FINAL` on one class is a contradiction and a syntax error — one says "subclass me", the other says "do not".

## The one that bites

`LOCAL FRIENDS` for the test class is convenient: the test reaches private methods and attributes. It is also how a test suite ends up asserting on internals, so that every refactoring breaks tests that were not testing behaviour. The alternative is to test through the public interface and treat a private method that *needs* its own test as a class that wants to exist. See [ABAP Unit](../../03_Topics/abap_unit/README.md).

## What this page still needs

- [ ] a `snippets/` program with an abstract base, a final subclass, a `CREATE PRIVATE` factory and an alias
- [ ] the compiler messages for instantiating an abstract class and subclassing a final one, recorded
- [ ] a before/after showing a `LOCAL FRIENDS` test converted to a behavioural one

## See also

- [`CLASS`](../class/README.md) — the definition these additions decorate
- [`INTERFACE` and `INTERFACES`](../interfaces/README.md) — what `ALIASES` shortens
- [`NEW`](../new/README.md) — what `CREATE PRIVATE` forbids to outsiders
- [ABAP Unit](../../03_Topics/abap_unit/README.md) — the `FRIENDS` trade-off
- [Object-oriented ABAP](../../03_Topics/oo_abap/README.md) — inheritance versus composition
