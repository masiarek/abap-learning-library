# Adding a lesson

The conventions are few, and most of them exist to keep one promise: **a page never claims something a program has not actually printed.**

## The shape of a lesson

```
NN_Section/
  topic_name/
    README.md                    the lesson
    examples/
      z_topic_name.prog.abap     a program that demonstrates it
      z_topic_name.out           its recorded output (the answer key)
    snippets/
      z_topic_name.prog.abap     a program NOBODY HAS RUN -- no .out, ever
```

A folder's overview page is named exactly `README.md`. GitHub only auto-renders a file with that name in a folder's tree view, and MkDocs turns it into that section's landing page — so the descriptive title goes in the page's `# H1`, not the filename.

**Name example files the abapGit way**: `<name>.<objecttype>.abap` — `z_hello_list.prog.abap`, `zcl_ballot.clas.abap`, `zif_tabulator.intf.abap`. abaplint types an object from that infix and analyses **nothing** without it; its way of telling you is the words `0 file(s) analyzed`, which look exactly like success. `tools/check_examples.py` refuses a plainly-named file for that reason. The answer key drops the type: `z_hello_list.out`.

## `examples/` or `snippets/` — the promise you are making

The two folders exist because this library has two honest positions, and blurring them is the one failure it cannot ship.

| | `examples/` | `snippets/` |
|---|---|---|
| Has been **run** | yes, by a human, in a named system | **no** |
| Has a `.out` | yes, mandatory | **never** — a transcript there is an error |
| Page may state results | yes, from the transcript | no |
| Block on the page | an `output:` block, a `source:` block | a `snippet:` block |
| Checked by abaplint | yes | yes |

Both folders are in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json)'s glob, so a snippet is parsed and syntax-checked exactly as an example is. What a snippet does **not** get is a claim about behaviour, and `check_examples.py` enforces that in both directions: a `.out` found in `snippets/` fails, and so does an `output:` block naming a snippet.

Know where that gate stops. abaplint has no copy of SAP's class library, so it catches an undefined variable, a malformed statement and an addition a statement does not take — and it cannot catch a misspelled method on `cl_abap_typedescr`, nor can it resolve a class that inherits from `cx_static_check`. When a page needs code that abaplint cannot type, put it in the prose as a fenced block and say that it is shown rather than checked. Fenced ABAP in the prose is illustration; only a `snippets/` or `examples/` file is machine-checked.

Write a new page's program into `snippets/` unless you have actually run it. Moving it to `examples/` later, with its transcript, is a promotion — and it is the only way a page earns an output block.

## The one rule

Mark where output belongs and let the tool fill it:

```markdown
<!-- output:z_topic_name -->
<!-- /output -->
```

Then run:

```bash
python3 tools/check_examples.py
```

It reads each example's recorded transcript and rewrites every block. Inside the markers is generated; outside is yours. `<!-- source:z_topic_name -->` pastes the program itself the same way, which is what a solution or a "here it is in full" section should use — a hand-pasted copy is one that can quietly stop matching the program that produced the output above it. CI runs `--check`, which writes nothing and fails if code, answer key, and page have drifted apart.

## Recording the answer key

This is the step the Rust library gets for free and this one does not. **Nothing in CI can run ABAP**, so you run the program yourself and record what it printed:

1. Run it in a real system — `SE38`, ADT, whatever you use.
2. Copy the output. Trim it to what the lesson is about; do not edit the numbers.
3. Save it as `examples/<name>.out`, with a provenance line first:

```text
#!recorded: A4H/001 · SAP_BASIS 7.58 · SE38 · 2026-08-13
Hello, ABAP
```

The provenance line is **mandatory** — `check_examples.py` fails without it — and it is not bureaucracy. It is the only signature the library has that a run happened at all, and it is what lets a reader in two years tell "this is what 7.58 does" from "this is what someone remembered". The tool strips it from the fence and prints it as the caption above the output.

Write down anything release-dependent in the prose too. A transcript from 7.58 is not a promise about 7.52, and the page should say which it is.

## Two things that are checked, and one that is not

- **abaplint** parses every example and syntax-checks it against the release in [`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json). Run it with `npx @abaplint/cli`. The config excludes `site/`, because MkDocs copies every `.abap` file into the built site and a stale copy there would otherwise be linted twice. It catches a typo'd statement, an unknown variable, an obsolete construct — real errors, before a reader copies them.
- **`check_examples.py --check`** proves the pages, the programs, and the recorded transcripts still agree.
- **Nobody checks that the transcript is real.** That is your signature. Do not paste output you did not see a system produce, and if you are illustrating something you cannot run, write it as prose or a labelled sketch — never as a recorded output block.

## Writing the prose

- **One idea per page.** If a page needs two H1-sized ideas, it is two pages.
- **Lead with the shortest true statement.** Open with a `**One line:**` summary a reader can carry away, then earn it.
- **Learner voice by default** — "you write", not "explain to your audience". A learner page serves a teacher fine; a teacher page fails a learner.
- **`**Level:**`** tags a page's depth: `101` (newcomer), `201` (working knowledge), `301` (deep dive), or `reference`, followed by ` · ` and the audience. Untagged is fine; malformed is not.
- **Say which trap you are describing.** The valuable half of most lessons is the mistake, not the mechanism.
- **Say which release you are describing.** ABAP's version spread is its defining fact: an inline `DATA(x)` is ordinary on 7.5x and a syntax error on 7.02, and half of the confusing answers online are someone else's release. Name yours.
- **Bridge to a language the reader already speaks.** Where an ABAP idea has a counterpart elsewhere, name it under an *"If you are coming from another language"* heading — one line per language, saying what transfers *and* what is genuinely different. Keep it honest: a bridge that glosses over a real difference costs more than it saves.
- **Don't hard-wrap paragraphs.** One paragraph, one line; Markdown collapses single newlines anyway. Keep real breaks only where they are semantic.

## Linking

- **Link a folder by naming its README**: `[label](some_folder/README.md)`, never `[label](some_folder/)`. The bare form works on GitHub and on the built site but not in a plain Markdown viewer, and MkDocs leaves it unrewritten — it ships to the page and 404s.
- **A repo path in backticks must be a link, not bare code text.** Paths are resolved from the *page's* folder by most readers, so a root-relative path in a code span dead-ends. Put the backticks in the label and a real relative path in the href.
- **Link a jargon term on first meaningful use**, once per page, and never to the page's own subject.

## Reading order in the sidebar

Set it in `NAV_ORDER` in [`mkdocs_hooks.py`](https://github.com/masiarek/abap-learning-library/blob/master/mkdocs_hooks.py) — **never by renaming files to `01_`, `02_`…** on a page. A filename is a permanent URL; inserting one lesson would otherwise move every page after it. Numeric prefixes on *section folders* are fine because folders move rarely and deliberately. A section's sidebar label is its README's `# H1` with the backticks dropped and everything from the em dash onwards trimmed off, so spell an acronym there ("ALV grid") and write the title as **`SUBJECT` — what it teaches**: "`LOOP AT` — `INTO` copies, `ASSIGNING` does not" labels the sidebar "LOOP AT" and still reads as a sentence at the top of the page. A title with no em dash is used whole. `FIXUPS` in the same file only fixes the fallback label a folder gets when it has no H1 — add the word there rather than renaming the folder.

## Before you commit

```bash
python3 tools/check_examples.py             # keys present, pages refilled
npx @abaplint/cli                           # every example parses and type-checks
uv run --group docs mkdocs build --strict   # the site builds clean
```

`--strict` turns a broken link into a build failure, which is the point — a dead link on the published site is invisible to everyone except the reader who tries to follow it.
