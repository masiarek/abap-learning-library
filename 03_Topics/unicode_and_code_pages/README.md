# Unicode and code pages — characters, bytes, and which code page you meant

**Level:** 201 · working knowledge

**One line:** A Unicode SAP system holds text as UTF-16 and can convert it to bytes in any code page it knows — `cl_abap_conv_codepage=>create_out( codepage = 'UTF-8' )` — and every place bytes leave or enter the system (a file, an HTTP body, an RFC to a non-Unicode partner) is a place where the code page has to be named, because the default is the system's own and the partner's is not.

## The three facts

1. **`string` is characters, `xstring` is bytes**, and nothing converts between them implicitly. `strlen( )` counts UTF-16 code units; `xstrlen( )` counts bytes; the number of bytes depends on the code page, so it is not a property of the text at all. [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) takes this further.
2. **Source code is ASCII by convention.** A non-ASCII literal can be corrupted in transport and is refused by this library's linter; build the character from its code point with `cl_abap_conv_in_ce=>uccp( '017C' )`.
3. **SAP names code pages by number as well as by name**: `4110` is UTF-8, `4102`/`4103` are UTF-16 BE/LE, `1100` is ISO-8859-1, `1160` is Windows-1252. `TCP00` lists them, and the older APIs (`cl_abap_conv_out_ce`, `OPEN DATASET … CODE PAGE`) take the number.

## Where it bites

- An interface file written with `ENCODING DEFAULT` on one system and read on another — see [`OPEN DATASET`](../../02_Keywords/open_dataset/README.md).
- A byte order mark the consumer did not expect, or expected and did not get.
- A non-Unicode partner system (still possible on old RFC destinations): characters outside its code page arrive as `#`.
- A `c` field sized in characters holding a name that needs more UTF-8 bytes than the interface allows — the [four lengths](https://masiarek.github.io/rust-learning-library/14_Strings/four_lengths/index.html) problem, in ABAP.

<!-- snippet:z_tp_unicode_and_code_pages -->
*[`z_tp_unicode_and_code_pages.prog.abap`](snippets/z_tp_unicode_and_code_pages.prog.abap) — pasted here by `tools/check_examples.py`. **Syntax-checked, never run:** abaplint parses and type-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json), but no system has produced output for it, so this page shows none.*

```abap
REPORT z_tp_unicode_and_code_pages.

" ABAP source should not carry non-ASCII characters (this library's linter
" refuses them, and transports have mangled them), so the Polish word is
" built from code points: Z a z-dot o-acute l-stroke c-acute.
DATA(lv_text) = `Za`
             && cl_abap_conv_in_ce=>uccp( '017C' )
             && cl_abap_conv_in_ce=>uccp( '00F3' )
             && cl_abap_conv_in_ce=>uccp( '0142' )
             && cl_abap_conv_in_ce=>uccp( '0107' ).

" Characters against bytes: strlen counts UTF-16 units, the byte count
" depends entirely on which code page you name.
WRITE: / 'strlen        ', strlen( lv_text ).

DATA(lv_utf8)  = cl_abap_conv_codepage=>create_out( codepage = `UTF-8` )->convert( lv_text ).
DATA(lv_utf16) = cl_abap_conv_codepage=>create_out( codepage = `UTF-16BE` )->convert( lv_text ).
WRITE: / 'UTF-8 bytes   ', xstrlen( lv_utf8 ).
WRITE: / 'UTF-16 bytes  ', xstrlen( lv_utf16 ).

" A round trip through the same code page gives the text back.
DATA(lv_back) = cl_abap_conv_codepage=>create_in( codepage = `UTF-8` )->convert( lv_utf8 ).
IF lv_back = lv_text.
  WRITE: / 'round trip through UTF-8 preserved the text'.
ENDIF.

" Through the WRONG code page, the same bytes are a different text, and no
" exception says so. This is what an interface file looks like from the
" other side when the encoding was never agreed.
DATA(lv_wrong) = cl_abap_conv_codepage=>create_in( codepage = `ISO-8859-1` )->convert( lv_utf8 ).
WRITE: / 'same bytes read as Latin-1, strlen', strlen( lv_wrong ).
```
<!-- /snippet -->

## If you are coming from another language

- **Python 3.** `str` / `bytes` with `.encode()` / `.decode()` is exactly `string` / `xstring` with `create_out` / `create_in`, including the rule that you name the encoding every time.
- **Java / C#.** UTF-16 strings, the same as ABAP's, with `getBytes(charset)` for the byte side.

## See also

- [How long is a string?](../../01_Foundations/how_long_is_a_string/README.md) — the recorded-run page
- [Strings and text](../strings_and_text/README.md) — the types
- [File handling](../file_handling/README.md) — the encoding decision at the file
- [HTTP client](../http_client/README.md) — the same decision on the wire
- The [encodings learning library](https://masiarek.github.io/encodings-learning-library/) — the subject on its own, across languages
