# DDIC, domains and data elements — a type that carries its own label

**Level:** 201 · working knowledge

**Status:** stub — the layer cake and the foreign key cardinality are here; the worked `ALPHA` example is not yet.

**One line:** The ABAP Dictionary is a type system with documentation attached: a **domain** holds the technical type and value range, a **data element** adds the field label, F1 help and search help, and a table field points at the data element — so a screen field gets its label, its help and its check table without a line of code.

## The layer cake

```
domain        ZFIN_D_AMOUNT     CURR, length 13, 2 decimals, value range
  └ data element  ZFIN_E_AMOUNT   labels (short/medium/long), F1 documentation, search help
      └ table field  ZFINT_DOC-AMOUNT   plus key, currency reference, foreign key
```

A local `TYPES` declaration has none of that. This is why a field on a selection screen declared `TYPE bukrs` arrives with a label, an input help and a check against `T001` for free, and one declared `TYPE c LENGTH 4` arrives naked. See [`PARAMETERS` and `SELECT-OPTIONS`](../../02_Keywords/parameters_select_options/README.md).

## What else the Dictionary decides

- **Foreign keys and check tables** — the input check, and the documented relationship between tables, with its cardinality. Below.
- **Fixed values** on a domain — a small, labelled value list, which is ABAP's oldest enumeration.
- **Conversion routines** (`ALPHA` above all) — why a material number is stored with leading zeros and displayed without them, and why comparing a screen value to a stored one fails until you convert.
- **Currency and quantity references** — a `CURR` field must name the field holding its currency key. See [Numbers and currency](../numbers_and_currency/README.md).
- **Append structures and includes** — how a customer field is added to an SAP table without modifying it.

## Foreign keys and cardinality

A foreign key on a table field says that the field's values must exist in another table, the **check table**, and it records how many rows on each side can match. That second part is the **cardinality**, and it is the same word the sibling math library defines in [cardinality of sets ↗](https://masiarek.github.io/math-learning-library/03_Sets/cardinality/index.html): |A| is the number of members of a set. Here the sets are "the check-table rows matching one foreign-key row" and "the foreign-key rows matching one check-table row", and the notation records the allowed range of each count.

Take invoices and customers. `VBRK` is the foreign key table, its customer field points at `KNA1`, the check table. Every invoice names exactly one customer, and a customer has 0, 1 or many invoices.

**In `SE11`, the check table is written first.** The cardinality field reads `n:m` with `n` for the check table and `m` for the foreign key table, so the invoice relationship is `1:CN`.

| side | values | meaning |
|---|---|---|
| left, check table | `1` | each foreign-key row has exactly one check-table row |
| | `C` | each foreign-key row has at most one; the field may be empty |
| right, foreign key table | `1` | each check-table row has exactly one foreign-key row |
| | `C` | 0 or 1 |
| | `N` | 1 or more |
| | `CN` | any number |

**In Dictionary DDL syntax, the foreign key table is written first.** The bracket reads `[n,m]` with `n` for the foreign key table and `m` for the check table, and the values are spelled as ranges: `1`, `0..1`, `1..*`, `0..*` on the foreign-key side, `1` or `0..1` on the check-table side. The same relationship is `[0..*,1]`. Shown, not checked; abaplint has no table DDL:

```
@AbapCatalog.foreignKey.keyType : #TEXT_KEY
@AbapCatalog.foreignKey.screenCheck : false
key label_id : zacb_label_id not null
  with foreign key [0..*,1] zacb_label
    where label_id = zacb_labelt.label_id;
```

**The trap:** the two notations are exactly inverted. `1:CN` in `SE11` and `[0..*,1]` in ADT describe one relationship. SAP changed the order when it introduced the DDL syntax, to the foreign-key-first order most people expect, and left `SE11` as it always was. Read a `SE11` cardinality with the DDL order, or the reverse, and you have swapped parent and child. This holds on 7.5x and in ABAP Cloud; the DDL form is the only one available for Dictionary objects in ADT-only systems.

The foreign key field type is the other half of the definition, and it says what the foreign key fields are in their own table:

- **Non-key fields / candidates** — the fields are not part of the foreign key table's primary key. A currency code on a custom table is the ordinary case.
- **Key fields / candidates** — the fields are in the primary key, or identify a row on their own.
- **Key fields of a text table** — the foreign key table is a **text table** for the check table: its key is the check table's key plus a language field, `SPRAS`. The cardinality is then `1:CN` by nature, one text row per language, and `SE16N` and F4 help use the relationship to show the translated text.

Cardinality is also what a join consumes. An inner join along a `1:CN` relationship returns one row per invoice, never per customer, and `SELECT SINGLE` on the many side silently drops all but one row; see [Open SQL](../open_sql/README.md) for the joins and [`SELECT`](../../02_Keywords/select/README.md) for `SELECT SINGLE` needing the full key. A many-to-many relationship, materials and plants for example, has no foreign key of its own and needs a link table, `MARC` between `MARA` and `T001W`, which then carries a `1:CN` foreign key to each side.

## If you are coming from another language

- **SQL DDL.** `REFERENCES` declares the same check, but plain SQL has no cardinality field; the "many" side is whatever a unique constraint on the referencing column allows. ABAP's `SE11` records the intended range as documentation and uses it for F4 help and for CDS associations.
- **UML.** The DDL bracket is UML multiplicity, `0..*` and `1..*` included, drawn at the component end of a composition. The `SE11` letters `C`, `N`, `CN` are the same ranges under older names.
- **ORMs.** `has_many` / `belongs_to` and their equivalents fix the direction by which class declares the relationship; `SE11` fixes it by which side is written first, which is why the DDL inversion catches people.

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
- [Conversion routines](../conversion_routines/README.md) — `ALPHA`, and the `SELECT` that finds nothing
- [Table types and buffering](../table_types_and_buffering/README.md) — technical settings, and the buffer that goes stale
- [Table maintenance](../table_maintenance/README.md) — `SM30` and the generator
- [Text elements and translation](../text_elements_and_translation/README.md) — nothing a user reads belongs in a literal
- [Open SQL](../open_sql/README.md) — the joins that walk a foreign key
- [Cardinality of sets ↗](https://masiarek.github.io/math-learning-library/03_Sets/cardinality/index.html) — the math library: |A| defined, the product rule, and the same word in types, indexes and telemetry
