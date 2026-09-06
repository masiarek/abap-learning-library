# How long is a string?

**Level:** 201 · working knowledge

**One line:** ABAP holds text as UTF-16, so `strlen( )` counts **code units** rather than the characters a reader would count, `xstrlen( )` counts bytes on an `xstring`, and there is no built-in that answers the question in between — which is why a name that fits a field on one system is truncated on another.

> **Status: the program is syntax-checked, but has never been run.** This library's rule is that a page never claims what a program has not printed, and no transcript exists for this one yet. What *has* been verified is narrower and worth stating exactly: the program below was checked once with `abaplint 2.120.19` against release v758 and came back **0 issues** — it parses, type-checks, and is clean under every rule in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json). It is not in an `examples/` folder, because a program there needs a recorded transcript beside it, so CI does not re-check it either. Treat the numbers as an argument; treat the code as valid ABAP. See [CONTRIBUTING](../../CONTRIBUTING.md) for why the distinction is enforced.

## Three questions that look like one

Ask "how long is this text" and you are really asking one of three things, and ABAP answers them with different constructs:

| you mean | ABAP | operates on |
|---|---|---|
| how many **bytes** on the wire or on disk | `xstrlen( lx )` | an `xstring` |
| how many **code units** the system stores | `strlen( lv )` | a `string` or `c` field |
| how many **characters a reader counts** | *nothing built in* | — |

For English text all three agree, which is exactly why the difference goes unnoticed for years. They come apart the moment the text does not fit the assumptions the code was written under.

## Why ABAP's answer is UTF-16 and not "characters"

A Unicode SAP system stores character data as UTF-16. That is a fixed **two bytes per code unit**, and the whole of the Basic Multilingual Plane — every Latin letter, every accented Polish letter, Cyrillic, Greek, CJK, the lot — fits in one code unit each. So for essentially all business text, one character is one code unit and `strlen( )` gives the answer you expected.

The exception is everything above U+FFFF: emoji, historic scripts, some rarer CJK. UTF-16 has no room for those in a single unit, so it encodes them as a **surrogate pair** — two code units standing in for one character. ABAP has no language-level concept of a surrogate pair; it sees two units.

> ⚠️ **Unverified.** The claim that follows from the above — that `strlen( '😀' )` returns **2** rather than 1 — is the one thing on this page nobody here has run. It is what UTF-16 storage implies and what the sibling libraries' bridges currently assert, but implication is not evidence. The program at the bottom settles it in ten seconds on any Unicode system; send the output and this box comes off.

The practical consequence, if it holds, is that `strlen( )` is a **storage** measure wearing the name of a **text** measure. That is not an ABAP peculiarity — Java's `String.length()`, C#'s, JavaScript's `.length` and SQL Server's `nvarchar(n)` all count the same units for the same reason. ABAP is in the majority here; it is Rust and Python that are unusual.

## The gap with no built-in

There is no `charlen( )`. If you need the count a person would give — "this name is six letters" — you walk the string yourself and skip the low half of each surrogate pair, or you accept the code-unit count and document it. Most SAP code does the second, correctly, because business text stays in the BMP and the two numbers are equal.

Where it stops being safe is a **fixed-width field**. A `CHAR(10)` holds ten code units, not ten characters. Text arriving from a web front end — a customer name, a free-text note, anything a person typed on a phone — can carry an emoji, and then ten characters may not fit and truncation can cut a surrogate pair in half, leaving a lone unit that is not a character in any encoding. That is the ABAP shape of a bug every language has its own version of.

## `string` and `xstring` do not convert implicitly

The bytes question is a different type, not a different method. `xstrlen( )` takes an `xstring`, and getting from text to bytes means naming a code page explicitly — `cl_abap_conv_codepage=>create_out( )` and its `create_in( )` counterpart. There is no default conversion, which is the same discipline Python 3 enforces with `.encode()` / `.decode()`: the moment you want bytes, you have to say *which* bytes.

That is also where the byte count stops being a property of the text at all. `'Zażółć'` is six characters, six UTF-16 code units, **ten** bytes in UTF-8 and **twelve** in UTF-16. Nothing about the `string` tells you which of those a downstream system will store.

## If you are coming from another language

- **Rust.** `.len()` is bytes — always, and O(1) — and `.chars().count()` is the scalar-value count ABAP has no built-in for. Rust's equivalent of `strlen( )` is `.encode_utf16().count()`, a method you have to know exists. The full four-way comparison is [Four lengths ↗](https://masiarek.github.io/rust-learning-library/14_Strings/four_lengths/index.html).
- **Python.** `len()` counts scalar values — the column ABAP lacks — and bytes need an explicit `len(s.encode("utf-8"))`. Python's answer is the one that most often surprises an ABAP developer, because it is *smaller* than expected for an emoji rather than larger. See [Counting characters ↗](https://masiarek.github.io/python-learning-library/01_Text_and_Bytes/counting_characters/index.html).
- **JavaScript / Java / C#.** `.length` counts UTF-16 code units, the same as `strlen( )`. If you are moving between ABAP and a browser front end, these two agree — which is convenient, and means a bug in the shared assumption shows up in neither until the data reaches a third system.

## Which release this describes

Unicode storage is the norm on any system you are likely to meet — non-Unicode systems were the older single-code-page kind and are long out of support — so this page assumes a Unicode system and does not distinguish 7.5x from 7.02. The program below uses no inline declarations, so it parses on old releases too.

## You cannot put the character in the source file

Here is the ABAP-specific turn, and it is not a detail. This library's linter refuses non-ASCII in an example, and the refusal is measurable:

```text
z_probe.prog.abap[4, 38] - Contains non 7 bit ascii character (7bit_ascii) [E]
abaplint: 1 issue(s) found, 1 file(s) analyzed
```

That is `abaplint` rejecting the literal `'Zaz...'` spelled with its real Polish letters. The rule is not squeamishness. ABAP **source code** has a code page of its own, separate from the data the program handles, and it has historically differed between systems — so a literal containing `ż` can arrive at another system as something else, and a transport can carry the damage silently. The safe way to put a non-ASCII character into ABAP source is to not put it there: build it from its code point.

That is why the program below reads `cl_abap_conv_in_ce=>uccp( '017C' )` instead of the letter. It is also why the emoji case is awkward in a way the Rust and Python versions are not — `uccp` takes **four** hex digits, which is one UTF-16 code unit, so U+1F600 cannot be expressed as a single call at all. You have to write the surrogate pair.

Notice what that means. The language's own tool for naming a character by number **cannot name a character above U+FFFF**. That is the UTF-16 storage model surfacing in the API, and it is the strongest available evidence for the claim in the box above — short of the run itself.

## Run it and settle the question

Paste this into `SE38` or ADT. It is the whole experiment.

```abap
REPORT z_how_long_is_a_string.

DATA: lv_text  TYPE string,
      lv_bytes TYPE xstring.

" 'Zazolc' with its Polish diacritics, built from code points rather than
" typed as literals -- see the section above for why that is not optional.
lv_text = 'Za'
       && cl_abap_conv_in_ce=>uccp( '017C' )    " z with dot above
       && cl_abap_conv_in_ce=>uccp( '00F3' )    " o acute
       && cl_abap_conv_in_ce=>uccp( '0142' )    " l stroke
       && cl_abap_conv_in_ce=>uccp( '0107' )    " c acute

WRITE: / 'ascii  strlen ', strlen( 'Nowak' ).
WRITE: / 'polish strlen ', strlen( lv_text ).

" Bytes are a different type, and the code page has to be named.
lv_bytes = cl_abap_conv_codepage=>create_out( codepage = 'UTF-8' )->convert( lv_text ).
WRITE: / 'polish xstrlen', xstrlen( lv_bytes ).
```

Expected, if the argument on this page holds: `strlen` of `'Nowak'` is 5, `strlen` of the Polish string is 6, and `xstrlen` of its UTF-8 form is **10** — six characters, ten bytes, because each diacritic costs two bytes in UTF-8 and none of them cost two in UTF-16.

Then the one that matters. Append `cl_abap_conv_in_ce=>uccp( 'D83D' ) && cl_abap_conv_in_ce=>uccp( 'DE00' )` — the two halves of U+1F600 — and print `strlen` of that. If it comes back **2**, the box at the top of this page comes off and every bridge in the sibling libraries is confirmed. If `uccp` refuses a surrogate half outright, that refusal is an answer too, and a more interesting one.

Send the output and this page gets its transcript, its `examples/` program, and the machine checks every other page here already has.

## See also

- [Four lengths ↗](https://masiarek.github.io/rust-learning-library/14_Strings/four_lengths/index.html) — the same question in Rust, with the fit/reject tables for a column limit
- [Meet the `char` ↗](https://masiarek.github.io/rust-learning-library/14_Strings/meet_the_char/index.html) — where the four counts come from
- [Counting characters ↗](https://masiarek.github.io/python-learning-library/01_Text_and_Bytes/counting_characters/index.html) — Python's answer, and what `wc` counts
