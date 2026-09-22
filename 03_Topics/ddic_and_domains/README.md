# DDIC, domains and data elements — a type that carries its own label

**Level:** 201 · working knowledge

**Status:** stub — the layer cake is here; the worked example is not yet.

**One line:** The ABAP Dictionary is a type system with documentation attached: a **domain** holds the technical type and value range, a **data element** adds the field label, F1 help and search help, and a table field points at the data element — so a screen field gets its label, its help and its check table without a line of code.

## The layer cake

```
domain        ZFIN_D_AMOUNT     CURR, length 13, 2 decimals, value range
  └ data element  ZFIN_E_AMOUNT   labels (short/medium/long), F1 documentation, search help
      └ table field  ZFINT_DOC-AMOUNT   plus key, currency reference, foreign key
```

A local `TYPES` declaration has none of that. This is why a field on a selection screen declared `TYPE bukrs` arrives with a label, an input help and a check against `T001` for free, and one declared `TYPE c LENGTH 4` arrives naked. See [`PARAMETERS` and `SELECT-OPTIONS`](../../02_Keywords/parameters_select_options/README.md).

## What else the Dictionary decides

- **Foreign keys and check tables** — the input check, and the documented relationship between tables.
- **Fixed values** on a domain — a small, labelled value list, which is ABAP's oldest enumeration.
- **Conversion routines** (`ALPHA` above all) — why a material number is stored with leading zeros and displayed without them, and why comparing a screen value to a stored one fails until you convert.
- **Currency and quantity references** — a `CURR` field must name the field holding its currency key. See [Numbers and currency](../numbers_and_currency/README.md).
- **Append structures and includes** — how a customer field is added to an SAP table without modifying it.

## What this page still needs

- [ ] a worked `ALPHA` conversion: the same material number in a table, on a screen, and in a `SELECT`
- [ ] table maintenance: `SE11`, `SE16N`, and what a table's delivery class implies for transports
- [ ] how a DDIC change is activated and what happens to existing data
- [ ] where CDS views replace DDIC views, and where they do not

## See also

- [`TYPES` and `CONSTANTS`](../../02_Keywords/types/README.md) — the local alternative, and its limits
- [CDS views](../cds_views/README.md) — the modern layer above the tables
- [Numbers and currency](../numbers_and_currency/README.md) — `CURR`, `QUAN` and their reference fields
- [Transports](../transports/README.md) — how a Dictionary change travels
