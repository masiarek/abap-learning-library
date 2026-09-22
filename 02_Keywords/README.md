# Keywords

**One line:** One page per ABAP keyword — what it does, the trap it comes with, and a program that demonstrates it.

ABAP's vocabulary is unusually large and unusually layered. Statements added in 1998 still work, still appear in production code, and sit three lines away from expressions added in 2013 that do the same job differently. A keyword page here answers four questions: **what it does**, **what it quietly does not do**, **which release it needs**, and **what to write instead** when the answer is "something newer".

Most pages carry a program in a `snippets/` folder. [Topics](../03_Topics/README.md) take the other cut through the same material: one page per *idea*, pulling several keywords together.

## What the machine checks here, and what it cannot

Every program under `snippets/` is parsed and syntax-checked by [abaplint](https://abaplint.org) on every push, against the release named in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json). **None of them has been run**, because [nothing in CI can run ABAP](../CONTRIBUTING.md) — so a snippet page shows code and never shows output. The [`examples/`](../01_Foundations/README.md) folder is the other half of that rule: a program in there *was* run by a human, and carries the transcript to prove it.

Knowing exactly where the gate stops matters more than the reassurance that one exists. Measured against abaplint 2.120.19:

| A mistake like this | Caught? |
|---|---|
| `lv_total = lv_does_not_exist + 1.` | **Yes** — `"lv_does_not_exist" not found, findTop (check_syntax)` |
| `FOR x IN itab WHERE ( table_line MOD 2 = 1 )` — arithmetic in a `WHERE` | **Yes**, as a parser error; the construct is not ABAP |
| `MESSAGE 'text' TYPE 'S' INTO lv_var.` — an addition that form does not take | **Yes**, as a parser error |
| `cl_abap_typedescr=>describe_by_data_no_such_method( x )` | **No** — the SAP class library is not in this repo, so a wrong method or parameter on a standard class passes untouched |
| A class that inherits from `cx_static_check` | Reported as *not found*, which is why local exception classes appear on the page as prose rather than in a snippet |

So: **the syntax is checked, the SAP-side names are not, and the behaviour is not.** Where a page states what a construct *produces*, it is stating the documented rule, not a recorded run.

## Declaring things

| Keyword | Page | In one line |
|---|---|---|
| `DATA` | [DATA — and `DATA( )`](data/README.md) | A variable, declared up front or born where it is first written |
| `TYPES`, `CONSTANTS` | [TYPES and CONSTANTS](types/README.md) | Naming a shape once so the rest of the program refers to it |
| `FIELD-SYMBOLS`, `ASSIGN` | [FIELD-SYMBOLS and ASSIGN](field_symbols/README.md) | Another name for memory you already have — and the dynamic escape hatch |
| `TYPES BEGIN OF ENUM` | [Enumerations](enum/README.md) | A fixed set of values the compiler can check |

## Building values

| Keyword | Page | In one line |
|---|---|---|
| `VALUE` | [VALUE](value/README.md) | A structure or a whole table as one expression |
| `FOR` | [FOR](for/README.md) | The loop that lives inside an expression |
| `REDUCE` | [REDUCE](reduce/README.md) | Many rows folded into one value |
| `FILTER` | [FILTER](filter/README.md) | A subset of a table, if the table has the right key |
| `CORRESPONDING` | [CORRESPONDING and MOVE-CORRESPONDING](corresponding/README.md) | Copy by matching names — and the difference that costs a field |
| `LET` | [LET](let/README.md) | A local name inside an expression |
| `NEW` | [NEW](new/README.md) | An object, or a data reference, in one expression |
| `CAST`, `CONV`, `EXACT` | [CAST, CONV and EXACT](cast_conv/README.md) | Changing the type of a reference, of a value, or refusing to |
| `\|…\|` | [String templates](string_templates/README.md) | Text with expressions in it, and formatting options that do the work |

## Choosing and repeating

| Keyword | Page | In one line |
|---|---|---|
| `IF`, `CASE` | [IF and CASE](case_if/README.md) | The statements — and when each is the wrong one |
| `COND`, `SWITCH` | [COND and SWITCH](cond_switch/README.md) | The same two choices as expressions |
| `DO`, `WHILE` | [DO and WHILE](do_while/README.md) | Counting loops, and `sy-index` |
| `CHECK`, `CONTINUE`, `EXIT`, `RETURN` | [CHECK, CONTINUE, EXIT, RETURN](check_continue_exit/README.md) | Four ways out, and only two of them mean what they look like |

## Internal tables

| Keyword | Page | In one line |
|---|---|---|
| `LOOP AT` | [LOOP AT](loop_at/README.md) | `INTO` copies, `ASSIGNING` does not, `GROUP BY` replaces the control break |
| `READ TABLE`, `itab[ ]` | [READ TABLE and table expressions](read_table/README.md) | `sy-subrc` or an exception — you choose which by how you write the read |
| `APPEND`, `INSERT`, `MODIFY`, `DELETE` | [Changing a table](itab_changes/README.md) | Which statement the table kind allows, and what each costs |
| `SORT`, `DELETE ADJACENT DUPLICATES` | [SORT and adjacent duplicates](sort/README.md) | The pair that must be used together, and usually is not |
| `DESCRIBE`, `lines( )` | [DESCRIBE and lines( )](describe_lines/README.md) | How many rows, and why the old statement lingers |

## Talking to the database

| Keyword | Page | In one line |
|---|---|---|
| `SELECT` | [SELECT](select/README.md) | Columns, joins, aggregates, and the `@` that the strict syntax insists on |
| `COMMIT WORK`, `ROLLBACK WORK` | [COMMIT WORK and ROLLBACK WORK](commit_work/README.md) | Where the database LUW ends, and what ends it without asking |
| `AUTHORITY-CHECK` | [AUTHORITY-CHECK](authority_check/README.md) | The check the database will not do for you |

## Text and files

| Keyword | Page | In one line |
|---|---|---|
| `CONCATENATE`, `SPLIT` | [CONCATENATE and SPLIT](concatenate_split/README.md) | The statements, and the expressions that replaced one of them |
| `FIND`, `REPLACE` | [FIND and REPLACE](find_replace/README.md) | Searching with and without regular expressions |
| `OPEN DATASET` | [OPEN DATASET](open_dataset/README.md) | Files on the application server, and the encoding you must name |

## Errors and messages

| Keyword | Page | In one line |
|---|---|---|
| `TRY`, `CATCH`, `RAISE` | [TRY, CATCH, RAISE](try_catch/README.md) | Class-based exceptions, and the three flavours the compiler treats differently |
| `MESSAGE` | [MESSAGE](message/README.md) | Six types, and each one decides what happens to the program next |
| `ASSERT` | [ASSERT](assert/README.md) | A claim that ends the program when it is false — on purpose |

## Objects and modularization

| Keyword | Page | In one line |
|---|---|---|
| `CLASS` | [CLASS](class/README.md) | Definition and implementation, visibility, inheritance |
| `INTERFACE`, `INTERFACES` | [INTERFACE and INTERFACES](interfaces/README.md) | The contract, and the `~` that names a method through it |
| `METHODS` | [METHODS and parameters](methods/README.md) | `IMPORTING`, `EXPORTING`, `CHANGING`, `RETURNING`, and which to reach for |
| `CALL FUNCTION` | [CALL FUNCTION](call_function/README.md) | Function modules, `DESTINATION`, and classic exceptions |
| `FORM`, `PERFORM` | [FORM and PERFORM](perform_form/README.md) | Obsolete, everywhere, and worth reading fluently |

## Screens and output

| Keyword | Page | In one line |
|---|---|---|
| `PARAMETERS`, `SELECT-OPTIONS` | [PARAMETERS and SELECT-OPTIONS](parameters_select_options/README.md) | The selection screen you get for free, and its ranges table |
| `WRITE` | [WRITE](write/README.md) | List output: still the fastest way to see a number, still not a UI |

## See also

- [Topics](../03_Topics/README.md) — the same language cut by idea instead of by keyword
- [Foundations](../01_Foundations/README.md) — the pages that have a recorded run behind them
- [Glossary](../GLOSSARY.md) — short definitions, each pointing at the page that earns it
- [Which release am I writing for?](../03_Topics/releases_and_syntax_levels/README.md) — the question behind half the answers on this shelf
