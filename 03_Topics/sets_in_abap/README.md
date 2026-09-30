# Sets in ABAP — a table with a unique key, and one idiom per operation

**Level:** 201 · working knowledge

**One line:** ABAP has no set type: a set is an internal table whose key is the whole line and is `UNIQUE`, membership is a keyed read, and union, intersection and difference are each one idiom built on `INSERT` and `FILTER` — with one trap, that `INSERT LINES OF` into a unique table **dumps** on a duplicate where a single `INSERT` only sets `sy-subrc = 4`.

## A set is a declaration

```abap
TYPES ty_set TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.
```

That one line is everything a set is. `UNIQUE KEY table_line` says that the whole line is the key and that no line may appear twice; `SORTED` gives it one canonical order, so it prints in order and two equal sets compare equal (more on that below). A `HASHED TABLE … WITH UNIQUE KEY table_line` is the other choice: one-step lookup whatever the size, no index and no order. For rows rather than numbers, name the components that make a row "the same" — `WITH UNIQUE KEY carrid connid` — and the table is a set of those keys, carrying the other columns along. See [Internal tables](../internal_tables/README.md) for what each kind costs.

A `STANDARD TABLE` is a **list**, not a set: it keeps duplicates and insertion order, and nothing in its type stops a repeat.

## One idiom per operation

| Operation | Math | Idiom | Needs |
|---|---|---|---|
| membership | x ∈ A | `line_exists( a[ table_line = x ] )` | a key on `a`, or it walks |
| add one | A ∪ {x} | `INSERT x INTO TABLE a.` — `sy-subrc = 4` if it was there | a unique key |
| deduplicate a list | — | `SORT l BY …` then `DELETE ADJACENT DUPLICATES FROM l COMPARING …` | the same fields in both |
| intersection | A ∩ B | `FILTER #( a IN b WHERE table_line = table_line )` | a sorted or hashed key on `b` |
| difference | A ∖ B | `FILTER #( a EXCEPT IN b WHERE table_line = table_line )` | a sorted or hashed key on `b` |
| union | A ∪ B | `a` plus `INSERT LINES OF` the difference B ∖ A | — |
| symmetric difference | A △ B | (A ∖ B) ∪ (B ∖ A) — two `EXCEPT IN`, then one union | — |
| subset | A ⊆ B | `lines( FILTER #( a EXCEPT IN b … ) ) = 0` | — |
| equality | A = B | `a = b`, **only** if both are sorted tables of the same type | see below |

### Membership

```abap
IF line_exists( lt_a[ table_line = 3 ] ).
```

`READ TABLE lt_a WITH TABLE KEY table_line = 3 TRANSPORTING NO FIELDS` followed by `IF sy-subrc = 0` is the older spelling of the same question. Either way, the read uses the table's key — a binary search on a sorted set, one step on a hashed one. On a standard table the same expression is a linear scan, which is why a set in ABAP is a *keyed* table and not just a list you promise not to repeat things in. [`READ TABLE`](../../02_Keywords/read_table/README.md) has both forms.

### Building a set: `INSERT` refuses, `APPEND` dumps

```abap
INSERT lv_n INTO TABLE lt_seen.
IF sy-subrc = 4.
  " it was already there -- nothing was inserted
ENDIF.
```

On a table with a unique **primary** key, `INSERT … INTO TABLE` of a line that is already there inserts nothing and sets `sy-subrc` to 4. It does not raise anything, and that is the useful behaviour for a set: the repeat is refused quietly, exactly as Python's `s.add(x)` or Rust's `HashSet::insert` (which returns `false`) ignore it. The same quietness is the danger — unchecked, `sy-subrc = 4` is a row silently missing from a result. See [Changing a table](../../02_Keywords/itab_changes/README.md).

Four near neighbours do **not** behave like that, and they are the traps on this page:

- **`APPEND` to a sorted table** does not refuse; it fails. The line must belong at the end in key order and must not repeat a unique key, and a line that breaks either is a runtime error — a short dump, not a `sy-subrc`. (`APPEND` to a hashed table does not even compile.) Use `INSERT … INTO TABLE` for anything that is not a plain list.
- **`INSERT LINES OF b INTO TABLE a`**, the obvious spelling of union, is a *mass* insert, and the ABAP keyword documentation treats duplicates there differently: a line whose unique **primary** key already exists is the non-catchable runtime error `ITAB_DUPLICATE_KEY`. One shared element between the two sets is enough. That is why the union below inserts only B ∖ A.
- **A unique *secondary* key** reports a duplicate with the catchable exception `CX_SY_ITAB_DUPLICATE_KEY` even on a single `INSERT` — the `sy-subrc = 4` rule is for the primary key only.
- **Constructing** a unique table with a repeated line — `VALUE ty_set( ( 1 ) ( 1 ) )`, or assigning a list that contains a repeat — is an error too, not a skip. Do not use a constructor expression to deduplicate.

The other way to deduplicate, when the table is a list you cannot retype, is the pair covered in [`SORT` and `DELETE ADJACENT DUPLICATES`](../../02_Keywords/sort/README.md): sort by the fields that decide sameness, then delete neighbours comparing the same fields. It is a statement you can forget in one branch; the unique key is a declaration you cannot.

### Intersection and difference: `FILTER … IN`

```abap
DATA(lt_both)   = FILTER #( lt_a IN lt_b WHERE table_line = table_line ).
DATA(lt_a_only) = FILTER #( lt_a EXCEPT IN lt_b WHERE table_line = table_line ).
```

This is [`FILTER`](../../02_Keywords/filter/README.md)'s second form: it keeps the lines of `lt_a` that have a partner in the **filter table** `lt_b` (or, with `EXCEPT`, that have none). The left side of each `WHERE` comparison is a column of `lt_a`, the right side a column of `lt_b`, so `table_line = table_line` means "the same value". The requirement sits on the filter table: `lt_b` must have a sorted or hashed key — its primary key, or a secondary key named with `USING KEY` — and the `WHERE` must cover it (every component with `=` for a hashed key, an initial part for a sorted one). A set declared as above has that key already, which is the quiet payoff of declaring sets as sets.

### Union: add only what is missing

```abap
DATA(lt_union) = lt_a.
DATA(lt_new)   = FILTER #( lt_b EXCEPT IN lt_a WHERE table_line = table_line ).
INSERT LINES OF lt_new INTO TABLE lt_union.
```

A ∪ B = A + (B ∖ A). The difference has no element in common with A, so the mass insert cannot meet a duplicate. The alternative is a `LOOP AT lt_b` with a single `INSERT` per line, ignoring `sy-subrc = 4` on purpose; it is longer and just as correct.

### Symmetric difference, and chaining it

A △ B is "in exactly one of the two": (A ∖ B) ∪ (B ∖ A), two `EXCEPT IN` filters and one union. Chained, it is not "in exactly one of the three" — it keeps what is in an **odd** number of the sets. With A = {0, 1, 2, 3, 4}, B = {2, 3, 4} and C = {2, 5}: A △ B = {0, 1}, and {0, 1} △ {2, 5} = {0, 1, 2, 5}. The 2 is in all three sets, three is odd, and it comes back. Python's `a ^ b ^ c` gives the same answer, for the same reason; the [algebra of sets ↗](https://masiarek.github.io/math-learning-library/04_Sets/algebra_of_sets/index.html) is where it is proved.

### Subset

A ⊆ B exactly when A ∖ B is empty: `lines( FILTER #( a EXCEPT IN b WHERE table_line = table_line ) ) = 0`. There is no shorter built-in.

### Equality: `=` compares lists, not sets

`=` on two internal tables compares them as sequences: first by the number of lines, then line by line, in order, and the first pair that differs decides. Two **standard** tables holding 1 2 3 and 3 2 1 are therefore *not* equal — they are equal as sets and different as lists, and `=` asks the list question.

A **sorted** table with a unique key removes the problem, because one content has exactly one order: build both sets as `ty_set` and `=` is set equality. A **hashed** table has no key order, and this page has not confirmed in which order `=` walks it, so do not rely on `=` for hashed sets built in different orders. For those, or for two tables of different kinds, test it the mathematical way: same number of lines, and one is a subset of the other.

<!-- snippet:z_tp_sets_in_abap -->
*[`z_tp_sets_in_abap.prog.abap`](snippets/z_tp_sets_in_abap.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_sets_in_abap.

" ABAP has no set type. A set is an internal table whose whole line is a
" UNIQUE key -- a sorted one here, so every set also prints in order.
TYPES ty_set  TYPE SORTED TABLE OF i WITH UNIQUE KEY table_line.
TYPES ty_list TYPE STANDARD TABLE OF i WITH EMPTY KEY.

" Each set operation is one idiom; the class only gives the idioms names.
CLASS lcl_set DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS union
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_set.
    CLASS-METHODS intersect
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_set.
    CLASS-METHODS minus
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_set.
    CLASS-METHODS xor
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE ty_set.
    CLASS-METHODS is_subset
      IMPORTING a             TYPE ty_set
                b             TYPE ty_set
      RETURNING VALUE(result) TYPE abap_bool.
    CLASS-METHODS show
      IMPORTING label TYPE string
                s     TYPE ty_set.
ENDCLASS.

CLASS lcl_set IMPLEMENTATION.
  METHOD union.
    " INSERT LINES OF into a unique table dumps on a duplicate key, where a
    " single INSERT only sets sy-subrc = 4. So add just what A lacks.
    result = a.
    DATA(lt_new) = FILTER #( b EXCEPT IN a WHERE table_line = table_line ).
    INSERT LINES OF lt_new INTO TABLE result.
  ENDMETHOD.

  METHOD intersect.
    " Keep the lines of A that have a partner in B. B is searched by its key.
    result = FILTER #( a IN b WHERE table_line = table_line ).
  ENDMETHOD.

  METHOD minus.
    " Keep the lines of A that have NO partner in B.
    result = FILTER #( a EXCEPT IN b WHERE table_line = table_line ).
  ENDMETHOD.

  METHOD xor.
    " In exactly one of the two: (A - B) together with (B - A).
    result = union( a = minus( a = a b = b ) b = minus( a = b b = a ) ).
  ENDMETHOD.

  METHOD is_subset.
    " A is a subset of B when nothing is left of A after removing B.
    result = xsdbool( lines( minus( a = a b = b ) ) = 0 ).
  ENDMETHOD.

  METHOD show.
    DATA(lv_text) = ``.
    LOOP AT s INTO DATA(lv_n).
      lv_text = |{ lv_text } { lv_n }|.
    ENDLOOP.
    WRITE: / label, '= {', lv_text, '}'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA(lt_a) = VALUE ty_set( ( 0 ) ( 1 ) ( 2 ) ( 3 ) ( 4 ) ).
  DATA(lt_b) = VALUE ty_set( ( 2 ) ( 3 ) ( 4 ) ).
  DATA(lt_c) = VALUE ty_set( ( 2 ) ( 5 ) ).

  " Membership is a keyed read: binary search here, one step on a hashed set.
  IF line_exists( lt_a[ table_line = 3 ] ).
    WRITE: / '3 is in A'.
  ENDIF.

  " Building a set: INSERT refuses a repeat with sy-subrc = 4, and no dump.
  DATA lt_seen TYPE ty_set.
  DATA(lt_raw) = VALUE ty_list( ( 3 ) ( 1 ) ( 3 ) ( 2 ) ( 1 ) ).
  LOOP AT lt_raw INTO DATA(lv_n).
    INSERT lv_n INTO TABLE lt_seen.
    IF sy-subrc = 4.
      WRITE: / 'repeat refused:', lv_n.
    ENDIF.
  ENDLOOP.
  lcl_set=>show( label = `seen` s = lt_seen ).

  " The same result for a list you cannot retype: sort, then drop neighbours.
  DATA(lt_dedup) = lt_raw.
  SORT lt_dedup BY table_line.
  DELETE ADJACENT DUPLICATES FROM lt_dedup COMPARING ALL FIELDS.
  WRITE: / 'deduplicated list has', lines( lt_dedup ), 'lines'.

  lcl_set=>show( label = `A | B` s = lcl_set=>union( a = lt_a b = lt_b ) ).
  lcl_set=>show( label = `A & B` s = lcl_set=>intersect( a = lt_a b = lt_b ) ).
  lcl_set=>show( label = `A - B` s = lcl_set=>minus( a = lt_a b = lt_b ) ).
  lcl_set=>show( label = `A ^ B` s = lcl_set=>xor( a = lt_a b = lt_b ) ).

  " Chained, symmetric difference keeps what is in an ODD number of the sets:
  " 2 is in all three, so it comes back.
  lcl_set=>show( label = `A ^ B ^ C`
                 s     = lcl_set=>xor( a = lcl_set=>xor( a = lt_a b = lt_b )
                                       b = lt_c ) ).

  IF lcl_set=>is_subset( a = lt_b b = lt_a ) = abap_true.
    WRITE: / 'B is a subset of A'.
  ENDIF.

  " = on two tables compares line by line, in order. Two lists holding the
  " same numbers in a different order are NOT equal ...
  DATA(lt_x) = VALUE ty_list( ( 1 ) ( 2 ) ( 3 ) ).
  DATA(lt_y) = VALUE ty_list( ( 3 ) ( 2 ) ( 1 ) ).
  IF lt_x <> lt_y.
    WRITE: / 'as lists, 1 2 3 <> 3 2 1'.
  ENDIF.

  " ... while a sorted unique table has one order for one content, so for it
  " = is set equality.
  DATA(lt_sx) = VALUE ty_set( ( 1 ) ( 2 ) ( 3 ) ).
  DATA(lt_sy) = VALUE ty_set( ( 3 ) ( 2 ) ( 1 ) ).
  IF lt_sx = lt_sy.
    WRITE: / 'as sorted sets, {1 2 3} = {3 2 1}'.
  ENDIF.
```
<!-- /snippet -->

## On the database: `DISTINCT`, `UNION`, `INTERSECT`, `EXCEPT`

When both sets are rows in the database, compute there instead of fetching both and filtering in memory. ABAP SQL has had `SELECT DISTINCT` for as long as it has had `SELECT`. **`UNION`** arrived in release **7.50**; like the SQL standard, a bare `UNION` is `UNION DISTINCT` and removes duplicate rows, and `UNION ALL` keeps them. **`INTERSECT`** and **`EXCEPT`** came later — release 7.56, as far as this page can tell (not confirmed against the release notes; check your own system's keyword documentation before you depend on it). Both return **distinct** rows. With any of the three, the syntax check runs in a strict mode, and the `INTO` clause goes after the *last* query rather than after the first.

<!-- snippet:z_tp_sets_sql -->
*[`z_tp_sets_sql.prog.abap`](snippets/z_tp_sets_sql.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_sets_sql.

" The flight demo tables ship with most training and sandbox systems. Swap them
" for your own; the set operator is the point.

START-OF-SELECTION.

  " SELECT DISTINCT: the result set as a set, duplicates removed by the database.
  SELECT DISTINCT carrid
    FROM spfli
    INTO TABLE @DATA(lt_carriers).
  WRITE: / 'carriers with a connection', lines( lt_carriers ).

  " UNION is UNION DISTINCT: a carrier flying both from and to Germany appears
  " once. UNION ALL would keep both rows. INTO comes after the last query.
  SELECT carrid FROM spfli WHERE countryfr = 'DE'
  UNION
  SELECT carrid FROM spfli WHERE countryto = 'DE'
    INTO TABLE @DATA(lt_from_or_to).
  WRITE: / 'from or to DE', lines( lt_from_or_to ).

  " INTERSECT: in both result sets.
  SELECT carrid FROM spfli WHERE countryfr = 'DE'
  INTERSECT
  SELECT carrid FROM spfli WHERE countryto = 'DE'
    INTO TABLE @DATA(lt_from_and_to).
  WRITE: / 'from and to DE', lines( lt_from_and_to ).

  " EXCEPT: in the first result set and not in the second.
  SELECT carrid FROM spfli WHERE countryfr = 'DE'
  EXCEPT
  SELECT carrid FROM spfli WHERE countryto = 'DE'
    INTO TABLE @DATA(lt_from_not_to).
  WRITE: / 'from but not to DE', lines( lt_from_not_to ).
```
<!-- /snippet -->

A ranges table (`TYPE RANGE OF`, `SELECT-OPTIONS`) is a set too, but a set described by conditions rather than listed: `IN` asks membership of a union of includes minus a union of excludes. See [Ranges tables](../../02_Keywords/ranges/README.md).

## If you are coming from another language

- **Python.** `set` is a type with operators (`|`, `&`, `-`, `^`, `<=`, `==`); in ABAP each is an idiom on a table you declared unique. `s.add(x)` ignoring a repeat is `INSERT … INTO TABLE` with `sy-subrc = 4`; there is no one-statement ABAP spelling of `s |= t` that is safe without first taking the difference. Python's `==` on two sets ignores order — ABAP's `=` does not, unless the tables are sorted. See [A set is a hash table ↗](https://masiarek.github.io/python-learning-library/04_Names_and_Objects/a_set_is_a_hash_table/index.html) and [Python sets ↗](https://masiarek.github.io/math-learning-library/04_Sets/python_sets/index.html).
- **Rust.** `HashSet` and `BTreeSet` are the hashed and sorted sets; `insert` returning `false` is ABAP's `sy-subrc = 4`, and `union`, `intersection`, `difference`, `symmetric_difference` and `is_subset` are methods rather than idioms. `==` on either is set equality, whatever order the elements went in — the question ABAP's `=` answers only for sorted tables. See [Set operations ↗](https://masiarek.github.io/rust-learning-library/26_Collections/set_operations/index.html) and [A first HashSet ↗](https://masiarek.github.io/rust-learning-library/26_Collections/a_first_hashset/index.html).
- **SQL.** `UNION`, `INTERSECT` and `EXCEPT` are the same words in ABAP SQL, with the same "distinct unless you say `ALL`" rule for `UNION`. `FILTER … IN` is a semi-join and `FILTER … EXCEPT IN` an anti-join, done in memory.

## See also

- [What is a set? ↗](https://masiarek.github.io/math-learning-library/04_Sets/what_is_a_set/index.html) — the math library: membership, and why order and repetition do not count
- [Algebra of sets ↗](https://masiarek.github.io/math-learning-library/04_Sets/algebra_of_sets/index.html) — union, intersection, difference, symmetric difference, and the laws they obey
- [Internal tables](../internal_tables/README.md) — sorted and hashed tables, and what a unique key costs
- [`FILTER`](../../02_Keywords/filter/README.md) — the operator behind intersection and difference
- [Changing a table](../../02_Keywords/itab_changes/README.md) — `INSERT`, `APPEND`, and the `sy-subrc = 4` on a duplicate
- [`SORT` and `DELETE ADJACENT DUPLICATES`](../../02_Keywords/sort/README.md) — deduplicating a list
- [`READ TABLE` and table expressions](../../02_Keywords/read_table/README.md) — `line_exists( )`, the membership test
- [Open SQL](../open_sql/README.md) — doing the set operation where the data is
