# Modern versus classic — what to write instead

**Level:** 201 · working knowledge

**One line:** A translation table from the ABAP you will read to the ABAP you should write — each row a construct that still works, its 7.40+ replacement, and the page that explains the difference — because the hardest part of modernising is not learning the new form but recognising the old one.

## The table

| You read | Write instead | Since | Page |
|---|---|---|---|
| `DATA lv TYPE i. lv = …` at the top of a 2,000-line report | `DATA(lv) = …` where it is used | 7.40 | [`DATA`](../../02_Keywords/data/README.md) |
| `CREATE OBJECT lo.` | `NEW` | 7.40 | [`NEW`](../../02_Keywords/new/README.md) |
| `MOVE a TO b.` `ADD 1 TO n.` | `=`, `+` | forever | [`MOVE`, `ADD`, `COMPUTE`](../../02_Keywords/move_add_compute/README.md) |
| `READ TABLE … WITH KEY … ` + `IF sy-subrc = 0` | `itab[ … ]`, `line_exists( )`, `OPTIONAL` | 7.40 | [`READ TABLE`](../../02_Keywords/read_table/README.md) |
| `LOOP AT … INTO wa.` … `MODIFY itab FROM wa.` | `LOOP AT … ASSIGNING` | 6.x | [`LOOP AT`](../../02_Keywords/loop_at/README.md) |
| `SORT` + `AT NEW` / `AT END OF` / `SUM` | `LOOP AT … GROUP BY` | 7.40 | [`AT NEW`](../../02_Keywords/at_new/README.md) |
| a work area, `APPEND` per row | `VALUE #( ( … ) ( … ) )` | 7.40 | [`VALUE`](../../02_Keywords/value/README.md) |
| a loop that builds a table from another | `VALUE #( FOR … )` | 7.40 | [`FOR`](../../02_Keywords/for/README.md) |
| a loop that totals | `REDUCE` | 7.40 | [`REDUCE`](../../02_Keywords/reduce/README.md) |
| `IF … ELSEIF … ENDIF` assigning one variable | `COND` | 7.40 | [`COND` and `SWITCH`](../../02_Keywords/cond_switch/README.md) |
| `CONCATENATE a b INTO c SEPARATED BY space.` | `\|{ a } { b }\|` | 7.02 | [String templates](../../02_Keywords/string_templates/README.md) |
| `CONDENSE lv.` `TRANSLATE lv TO UPPER CASE.` | `condense( )`, `to_upper( )` | 7.02 | [In-place string statements](../../02_Keywords/condense_translate_shift/README.md) |
| `FIND REGEX` | `FIND PCRE` | 7.55 | [Regular expressions](../regular_expressions/README.md) |
| `SELECT * … INTO TABLE lt WHERE f = v.` | `SELECT f1, f2 … WHERE f = @v INTO TABLE @DATA(lt).` | 7.40 SP05 | [`SELECT`](../../02_Keywords/select/README.md) |
| `SELECT … ENDSELECT` over a small set | `INTO TABLE` | forever | [Cursors](../../02_Keywords/open_cursor_fetch/README.md) |
| a second `SELECT` in a `LOOP` | a join, or a hashed lookup | forever | [Open SQL](../open_sql/README.md) |
| `RAISE EXCEPTION TYPE zcx EXPORTING …` | `RAISE EXCEPTION NEW zcx( … )` | 7.52 | [`TRY`, `CATCH`, `RAISE`](../../02_Keywords/try_catch/README.md) |
| `CATCH SYSTEM-EXCEPTIONS` | `TRY … CATCH cx_sy_…` | 6.10 | [Exceptions](../exceptions/README.md) |
| `TRY … CAST … CATCH cx_sy_move_cast_error` as a type test | `IS INSTANCE OF`, `CASE TYPE OF` | 7.50 | [`CASE TYPE OF`](../../02_Keywords/case_type_of/README.md) |
| `IF flag = 'X'.` | `IF flag = abap_true.`; `xsdbool( )` | 7.02 | [Booleans](../../02_Keywords/boolean_functions/README.md) |
| `CONSTANTS: BEGIN OF gc_status, … END OF gc_status.` | `TYPES BEGIN OF ENUM` | 7.51 | [Enumerations](../../02_Keywords/enum/README.md) |
| `RANGES r FOR f.` | `TYPE RANGE OF` | 7.0 | [Ranges tables](../../02_Keywords/ranges/README.md) |
| `TABLES`, `OCCURS`, `WITH HEADER LINE`, `TYPE-POOLS` | plain `DATA` and `TYPES` | 6.10 | [Obsolete declarations](../../02_Keywords/obsolete_declarations/README.md) |
| `FORM` / `PERFORM` | a method on a local class | 4.6 | [`FORM` and `PERFORM`](../../02_Keywords/perform_form/README.md) |
| `REUSE_ALV_GRID_DISPLAY` | `cl_salv_table` | 7.0 | [ALV](../alv/README.md) |
| `WRITE` as a UI | ALV | forever | [`WRITE`](../../02_Keywords/write/README.md) |
| `EXEC SQL` | ADBC, or Open SQL | 7.0 | [Native SQL](../native_sql/README.md) |
| `DEFINE` macros | methods | forever | [`DEFINE`](../../02_Keywords/define_macro/README.md) |
| `BREAK-POINT.` | `BREAK-POINT ID`, or none | 6.20 | [Checkpoint groups](../../02_Keywords/break_point_log_point/README.md) |

## The rule about when

Every left-hand column still compiles on an on-premise system. Rewrite when the module is being reworked; do not rewrite in a bug fix, and do not rewrite in a system whose oldest member cannot run the right-hand column — see [Which release am I writing for?](../releases_and_syntax_levels/README.md). ABAP Cloud is the exception: there, several left-hand rows do not compile at all.

## See also

- [Constructor expressions](../constructor_expressions/README.md) — the new family, as a family
- [Clean ABAP](../clean_abap/README.md) — the style argument
- [ATC and Code Inspector](../atc_and_code_inspector/README.md) — the checks that flag the left column
- [ABAP Cloud](../abap_cloud/README.md) — where the left column stops compiling
