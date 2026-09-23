# Constructor expressions — the `VALUE`, `NEW`, `CONV`, `COND` family

**Level:** 201 · working knowledge

**One line:** Since 7.40 a family of operators builds a value *inside* an expression — `VALUE`, `NEW`, `CONV`, `CAST`, `REF`, `EXACT`, `COND`, `SWITCH`, `CORRESPONDING`, `REDUCE`, `FILTER` — all sharing one grammar (`OPERATOR type( … )`, with `#` for "infer the type") and one consequence: fewer helper variables, and longer lines.

## The family

| Operator | Builds | Page |
|---|---|---|
| `VALUE` | a structure or table | [`VALUE`](../../02_Keywords/value/README.md) |
| `NEW` | an object or data reference | [`NEW`](../../02_Keywords/new/README.md) |
| `CONV` | a value of another type | [`CAST`, `CONV` and `EXACT`](../../02_Keywords/cast_conv/README.md) |
| `CAST` | a reference of another static type | same |
| `EXACT` | a converted value, or an exception | same |
| `REF` | a reference to an existing variable | [Data references](../../02_Keywords/data_references/README.md) |
| `COND` | a value chosen by conditions | [`COND` and `SWITCH`](../../02_Keywords/cond_switch/README.md) |
| `SWITCH` | a value chosen by cases | same |
| `CORRESPONDING` | a structure copied by component name | [`CORRESPONDING`](../../02_Keywords/corresponding/README.md) |
| `REDUCE` | one value folded from a table | [`REDUCE`](../../02_Keywords/reduce/README.md) |
| `FILTER` | a subset of a table | [`FILTER`](../../02_Keywords/filter/README.md) |

Inside most of them: [`FOR`](../../02_Keywords/for/README.md) to iterate, [`LET`](../../02_Keywords/let/README.md) to name a temporary, `BASE` to start from an existing value, and `THROW` to raise instead of returning.

## The one grammar

```abap
OPERATOR type( … )        " the type is named
OPERATOR #( … )           " the type is inferred from where the result goes
```

`#` works only where the context supplies a type — an assignment to a typed variable, a typed parameter, a `RETURNING` value. In an inline `DATA( )` there is no context, so the type has to be spelled out. That one rule explains nearly every "`#` cannot be inferred here" error.

## When to stop

A constructor expression is a value, so it can nest without limit, and the limit that matters is the reader's. A `VALUE` containing a `FOR` containing a `COND` containing a `REDUCE` is one statement with no line the debugger can stop on usefully. The test from [Clean ABAP](../clean_abap/README.md): if a colleague needs to count parentheses, it was two statements.

## If you are coming from another language

- **Rust / Kotlin / Scala.** Everything is an expression there; ABAP is a statement language that grew expression forms for the common cases. `COND` is `if` as an expression, `REDUCE` is `fold`, `VALUE … FOR` is a comprehension.
- **Java.** Streams and the ternary, without the laziness.

## See also

- [Modern versus classic](../modern_vs_classic/README.md) — each operator beside the statement it replaced
- [Which release am I writing for?](../releases_and_syntax_levels/README.md) — 7.40, where all of this arrived
- [Keywords](../../02_Keywords/README.md) — the individual pages
