# ABAP — Learning Library

<!-- --8<-- [start:hero] -->

A learning library for ABAP, built the same way as its sibling [rust-learning-library](https://github.com/masiarek/rust-learning-library): **one idea per page, and every claim backed by a program that was actually run.**

No page here hand-types what a program printed. Each lesson links a real `.abap` file and a recorded transcript of running it; a tool pastes that transcript into the page and CI fails if the two drift apart. So when a page says *"this writes `3 records updated`"*, that is not a recollection — it is a record.

📖 **Read it as a site:** <https://masiarek.github.io/abap-learning-library/>

<!-- --8<-- [end:hero] -->

<!-- --8<-- [start:below-hero] -->

## The one rule, and the one honest caveat

The Rust library can say something stronger than this one: its CI compiles and runs every example on every push. **Nothing in CI can run ABAP** — a GitHub runner has no SAP system, and there is no free ABAP runtime to install. Pretending otherwise would be the one failure a teaching library must never ship, so the promise moves back one step instead:

> A human ran the program **once**, in a **named system**, and pasted the transcript into `<name>.out`. From that moment nothing may quietly disagree with that file.

Which is why every answer key opens with a provenance line:

```text
#!recorded: A4H/001 · SAP_BASIS 7.58 · SE38 · 2026-08-13
```

The tool strips that line out of the code fence and prints it as the caption above the output, so a reader always sees **which system and which release** produced the numbers. A page written from memory has nowhere to hide: it has no `.out`, so it has no output block.

**What CI does enforce**, on every push:

| Check | Tool |
|---|---|
| Every example parses and passes a syntax check against a configured release (7.58) | [abaplint](https://abaplint.org) |
| Every `examples/` program has a recorded transcript, and that transcript says where it was run | `tools/check_examples.py` |
| No `snippets/` program has a transcript, and no page claims output for one | `tools/check_examples.py` |
| Every generated block on every page still matches the transcript beside the program | `tools/check_examples.py --check` |

**What CI cannot enforce** is that the transcript is what your system really printed. That part is a human signature, and the provenance line is where it is signed.

## How the library works

```
01_Foundations/
  <topic>/
    README.md                      the lesson (prose + code + a generated output block)
    examples/
      z_topic.prog.abap            the program the lesson is about
      z_topic.out                  its recorded output — the answer key
02_Keywords/  03_Topics/
  <topic>/
    README.md                      the page
    snippets/
      z_kw_topic.prog.abap         a program that was syntax-checked but NEVER run
tools/check_examples.py            checks the keys and refills the pages
```

**Two folders, two different promises.** A program in `examples/` was **run** by a human and has a transcript beside it, so its page may state results. A program in `snippets/` has only been **parsed and syntax-checked** by abaplint — it has no `.out`, may never have one, and its page shows code and no output. The checker enforces the split in both directions: a transcript found inside `snippets/` is an error, and an `output:` block pointing at a snippet is an error too. That is how the shelf can grow past what one person has had time to run without ever blurring the line between *this compiles* and *this printed*.

A lesson marks the spot where output belongs and lets the tool fill it:

```markdown
<!-- output:z_topic -->
<!-- /output -->
```

Inside the markers is generated; outside is yours. `<!-- source:z_topic -->` does the same for the program itself, so a lesson cannot drift from the file its numbers came from. Run the tool after any change:

```bash
python3 tools/check_examples.py
```

**Example files are named the abapGit way** — `<name>.<objecttype>.abap`, as in `z_hello_list.prog.abap` or `zcl_ballot.clas.abap`. That is not decoration: abaplint identifies an object by that infix and quietly analyses **zero** files without it, so a plainly-named example would sail through CI unchecked. The happy side effect is that any example can be pulled straight into a system with abapGit.

## Running things

| Task | Command |
|---|---|
| Check every example and refresh the pages | `python3 tools/check_examples.py` |
| Check without writing (what CI runs) | `python3 tools/check_examples.py --check` |
| Work on one lesson without touching the others | `python3 tools/check_examples.py --only z_topic` |
| Syntax-check every example | `npx @abaplint/cli` |
| Preview the site locally | `uv run --group docs mkdocs serve` |

Only Python 3.11+ is needed to check the pages; `npx` for abaplint, and `uv` only to preview the site.

## Start here

Three shelves, three different cuts through the same language:

- **[Foundations](01_Foundations/README.md)** — one idea per page, with a program beside it. This is where a lesson lands once someone has *run* it.
- **[Keywords](02_Keywords/README.md)** — one page per keyword: what it does, the trap it comes with, which release it needs, and what to write instead when the answer is "something newer". Most pages carry a syntax-checked program.
- **[Topics](03_Topics/README.md)** — one page per idea: internal tables, Open SQL, exceptions, ABAP Unit, RAP, performance, and the rest of what has to be understood rather than looked up.

The [glossary](GLOSSARY.md) is the short way in: every entry points at the page that earns it.

## Adding a lesson

See [CONTRIBUTING.md](CONTRIBUTING.md) — it is short, and it is mostly about the one rule above.

<!-- --8<-- [end:below-hero] -->
