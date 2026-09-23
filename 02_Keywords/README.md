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
| `REF`, `REF TO data`, `->*` | [Data references](data_references/README.md) | A value that points at memory, and can be kept and stored |
| `STATICS` | [STATICS](statics/README.md) | A local variable that survives between calls |
| `TYPES BEGIN OF ENUM` | [Enumerations](enum/README.md) | A fixed set of values the compiler can check |
| `TYPE RANGE OF` | [Ranges tables](ranges/README.md) | Sign, option, low, high — what a `SELECT-OPTIONS` hands you |
| `TYPES BEGIN OF MESH` | [Meshes](mesh/README.md) | Tables with declared associations between them; rare, and worth recognising |

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
| `xsdbool( )`, `boolc( )` | [Booleans](boolean_functions/README.md) | There is no boolean type; here is the convention, and the trap |
| `abs`, `round`, `nmax`, `DIV`, `MOD` | [Numeric functions and operators](numeric_functions/README.md) | Rounding modes, integer operators, and the `MOD` that is never negative |

## Choosing and repeating

| Keyword | Page | In one line |
|---|---|---|
| `IF`, `CASE` | [IF and CASE](case_if/README.md) | The statements — and when each is the wrong one |
| `COND`, `SWITCH` | [COND and SWITCH](cond_switch/README.md) | The same two choices as expressions |
| `CASE TYPE OF`, `IS INSTANCE OF` | [CASE TYPE OF](case_type_of/README.md) | Branching on an object's class — and why that is usually a missing method |
| `DO`, `WHILE` | [DO and WHILE](do_while/README.md) | Counting loops, and `sy-index` |
| `CHECK`, `CONTINUE`, `EXIT`, `RETURN` | [CHECK, CONTINUE, EXIT, RETURN](check_continue_exit/README.md) | Four ways out, and only two of them mean what they look like |
| `LEAVE`, `STOP` | [LEAVE and STOP](leave_and_stop/README.md) | Leaving a screen, a list, a transaction or the program |

## Internal tables

| Keyword | Page | In one line |
|---|---|---|
| `LOOP AT` | [LOOP AT](loop_at/README.md) | `INTO` copies, `ASSIGNING` does not, `GROUP BY` replaces the control break |
| `READ TABLE`, `itab[ ]` | [READ TABLE and table expressions](read_table/README.md) | `sy-subrc` or an exception — you choose which by how you write the read |
| `APPEND`, `INSERT`, `MODIFY`, `DELETE` | [Changing a table](itab_changes/README.md) | Which statement the table kind allows, and what each costs |
| `COLLECT` | [COLLECT](collect/README.md) | Summing rows into a table by key, in one statement |
| `SORT`, `DELETE ADJACENT DUPLICATES` | [SORT and adjacent duplicates](sort/README.md) | The pair that must be used together, and usually is not |
| `AT NEW`, `AT END OF`, `SUM` | [Control breaks](at_new/README.md) | Totals per group the 1990s way, and the masking rule nobody expects |
| `DESCRIBE`, `lines( )` | [DESCRIBE and lines( )](describe_lines/README.md) | How many rows, and why the old statement lingers |

## Talking to the database

| Keyword | Page | In one line |
|---|---|---|
| `SELECT` | [SELECT](select/README.md) | Columns, joins, aggregates, and the `@` that the strict syntax insists on |
| `INSERT`, `UPDATE`, `MODIFY`, `DELETE` | [Database writes](db_writes/README.md) | Four write statements, `sy-dbcnt`, and the commit that is a separate decision |
| `WITH` | [WITH — common table expressions](with_cte/README.md) | A named subquery, used like a table, in one round trip (7.51) |
| `OPEN CURSOR`, `FETCH`, `SELECT … ENDSELECT` | [Cursors](open_cursor_fetch/README.md) | Reading a result set too big to hold, and the commit that closes it |
| `EXEC SQL`, ADBC | [Native SQL](exec_sql/README.md) | Bypassing Open SQL, and everything that bypasses with it |
| `COMMIT WORK`, `ROLLBACK WORK` | [COMMIT WORK and ROLLBACK WORK](commit_work/README.md) | Where the database LUW ends, and what ends it without asking |
| `AUTHORITY-CHECK` | [AUTHORITY-CHECK](authority_check/README.md) | The check the database will not do for you |

## Text and files

| Keyword | Page | In one line |
|---|---|---|
| `CONCATENATE`, `SPLIT` | [CONCATENATE and SPLIT](concatenate_split/README.md) | The statements, and the expressions that replaced one of them |
| `CONDENSE`, `TRANSLATE`, `SHIFT` | [In-place string statements](condense_translate_shift/README.md) | Change the variable where it stands — and the function twins that return a value |
| `FIND`, `REPLACE` | [FIND and REPLACE](find_replace/README.md) | Searching with and without regular expressions |
| `CALL TRANSFORMATION` | [CALL TRANSFORMATION](call_transformation/README.md) | ABAP to XML and JSON, with the identity transformation and your own |
| `OPEN DATASET` | [OPEN DATASET](open_dataset/README.md) | Files on the application server, and the encoding you must name |

## Errors and messages

| Keyword | Page | In one line |
|---|---|---|
| `TRY`, `CATCH`, `RAISE` | [TRY, CATCH, RAISE](try_catch/README.md) | Class-based exceptions, and the three flavours the compiler treats differently |
| `RETRY`, `RESUME`, `RESUMABLE` | [RETRY and RESUME](retry_resume/README.md) | Going back after an exception — the batch that must not stop |
| `RAISE SHORTDUMP` | [RAISE SHORTDUMP](raise_shortdump/README.md) | A dump on purpose, carrying the facts (7.53) |
| `MESSAGE` | [MESSAGE](message/README.md) | Six types, and each one decides what happens to the program next |
| `ASSERT` | [ASSERT](assert/README.md) | A claim that ends the program when it is false — on purpose |
| `BREAK-POINT`, `LOG-POINT`, `ASSERT ID` | [Checkpoint groups](break_point_log_point/README.md) | Debugging aids that stay in shipped code and never fire unless switched on |

## Objects and modularization

| Keyword | Page | In one line |
|---|---|---|
| `CLASS` | [CLASS](class/README.md) | Definition and implementation, visibility, inheritance |
| `INTERFACE`, `INTERFACES` | [INTERFACE and INTERFACES](interfaces/README.md) | The contract, and the `~` that names a method through it |
| `METHODS` | [METHODS and parameters](methods/README.md) | `IMPORTING`, `EXPORTING`, `CHANGING`, `RETURNING`, and which to reach for |
| `EVENTS`, `RAISE EVENT`, `SET HANDLER` | [Events](events/README.md) | Objects that publish, and the handlers that subscribe |
| `FRIENDS`, `ALIASES`, `ABSTRACT`, `FINAL` | [The class additions](friends_aliases_abstract/README.md) | Who may instantiate, inherit, see the private section, or use a short name |
| `CALL FUNCTION` | [CALL FUNCTION](call_function/README.md) | Function modules, `DESTINATION`, and classic exceptions |
| `GET BADI`, `CALL BADI` | [GET BADI and CALL BADI](get_badi/README.md) | Calling an enhancement spot, and finding out whether yours will run |
| `ENHANCEMENT-POINT`, `ENHANCEMENT-SECTION` | [Enhancement points](enhancement_point/README.md) | Source-level hooks in SAP's code, explicit and implicit |

## Programs, screens and output

| Keyword | Page | In one line |
|---|---|---|
| `INITIALIZATION`, `AT SELECTION-SCREEN`, `START-OF-SELECTION` | [Report events](report_events/README.md) | A report is event blocks in a fixed order, not a script |
| `PARAMETERS`, `SELECT-OPTIONS` | [PARAMETERS and SELECT-OPTIONS](parameters_select_options/README.md) | The selection screen you get for free, and its ranges table |
| `SUBMIT` | [SUBMIT](submit/README.md) | Running another report, with its parameters, its list, or as a job |
| `CALL TRANSACTION`, `LEAVE TO TRANSACTION` | [CALL TRANSACTION](call_transaction/README.md) | Running a transaction from code — with or without driving its screens |
| `EXPORT`, `IMPORT`, `SET`/`GET PARAMETER` | [EXPORT and IMPORT](export_import/README.md) | ABAP memory, SAP memory and the shared buffer |
| `CALL SCREEN`, `MODULE`, `PROCESS BEFORE OUTPUT` | [Classic screens](call_screen/README.md) | Dynpros and flow logic — the model every classic transaction runs on |
| `WRITE` | [WRITE](write/README.md) | List output: still the fastest way to see a number, still not a UI |

## The system, and time

| Keyword | Page | In one line |
|---|---|---|
| `sy-subrc`, `sy-tabix`, `sy-index`, … | [System fields](sy_fields/README.md) | The structure the kernel keeps for you, and the three fields that cause bugs |
| `GET TIME`, `GET RUN TIME`, `GET TIME STAMP`, `WAIT` | [Asking what time it is](get_time/README.md) | Refreshing the clock, timing a block, and the `WAIT` that commits |

## Legacy you will read

| Keyword | Page | In one line |
|---|---|---|
| `FORM`, `PERFORM` | [FORM and PERFORM](perform_form/README.md) | Obsolete, everywhere, and worth reading fluently |
| `TABLES`, `OCCURS`, `WITH HEADER LINE`, `RANGES`, `TYPE-POOLS` | [Obsolete declarations](obsolete_declarations/README.md) | Recognise them, and the header line above all |
| `MOVE`, `ADD`, `SUBTRACT`, `COMPUTE` | [Obsolete statements](move_add_compute/README.md) | Assignment and arithmetic before operators existed |
| `DEFINE` | [Macros](define_macro/README.md) | Text substitution you cannot debug |

## See also

- [Topics](../03_Topics/README.md) — the same language cut by idea instead of by keyword
- [Modern versus classic](../03_Topics/modern_vs_classic/README.md) — every construct on this shelf beside what replaced it
- [Constructor expressions](../03_Topics/constructor_expressions/README.md) — the `VALUE`/`NEW`/`COND` family as a family
- [Foundations](../01_Foundations/README.md) — the pages that have a recorded run behind them
- [Glossary](../GLOSSARY.md) — short definitions, each pointing at the page that earns it
- [Which release am I writing for?](../03_Topics/releases_and_syntax_levels/README.md) — the question behind half the answers on this shelf
