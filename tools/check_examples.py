#!/usr/bin/env python3
"""Hold every lesson page to the output its example program actually produced.

This is the spine of the library, and it is the sibling of
rust-learning-library's `run_examples.py` with one honest difference: **nothing
here can run the program for you.** ABAP runs in an SAP system, and no CI runner
has one. So the trust model moves one step back:

    the program was run BY A HUMAN, once, in a named system,
    its transcript was pasted into <stem>.out,
    and from then on nothing may quietly disagree with that file.

A page never hand-types what a program printed; it marks the spot and this tool
fills it from the recorded transcript:

    <!-- output:hello_write -->
    <!-- /output -->

Inside the markers is generated, outside is yours. `source:` blocks work the same
way and paste the program itself, so a lesson cannot drift from the file its
numbers came from.

Two folders, two different promises
-----------------------------------
    examples/   a program a human RAN. Has a <stem>.out beside it. `output:` and
                `source:` blocks come from here, and the page may state results.
    snippets/   a program nobody has run. Has NO .out, and never may. `snippet:`
                blocks come from here; abaplint still parses and syntax-checks it,
                so the page may state that the code is valid ABAP -- and nothing
                more. A keyword page that demonstrates a construct without an SAP
                system to run it in belongs here; the caption says so in words.

The split exists so the library can grow past what one person has had time to run
without ever blurring the line between "this compiles" and "this printed".

Because the machine cannot vouch for the run, **the answer key must say where it
came from**. Every `.out` starts with a provenance line:

    #!recorded: A4H/001 · SAP_BASIS 7.58 · SE38 · 2026-08-13

That line is stripped from the fence and shown as the caption above it, so every
reader can see which system and release produced the numbers — and a page that
was written from memory has nowhere to hide.

Two modes
---------
    python3 tools/check_examples.py            verify + refill the .md blocks
    python3 tools/check_examples.py --check    write nothing; fail on drift  (CI)
    python3 tools/check_examples.py --only X   touch example X and nothing else

An example is any ``*.abap`` under a folder named ``examples/``, named the abapGit
way — ``<name>.<objecttype>.abap`` — because abaplint recognises nothing else. Its
answer key is the sibling ``<name>.out``. Stems must be unique repo-wide, because a Markdown
block names a bare stem with no path.

Stdlib only, on purpose: reading this library should not require installing
anything, and neither should checking it.
"""

from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent

# The first line of every .out: where this transcript was produced.
PROVENANCE = re.compile(r"^#!recorded:\s*(?P<where>.+?)\s*$")

# <!-- output:stem -->  ...generated...  <!-- /output -->
# <!-- source:stem -->  ...generated...  <!-- /source -->
BLOCK = re.compile(
    r"(?P<open><!--\s*(?P<kind>output|source|snippet):(?P<stem>[A-Za-z0-9_\-]+)\s*-->)"
    r"(?P<body>.*?)"
    r"(?P<close><!--\s*/(?P=kind)\s*-->)",
    re.DOTALL,
)

SKIP_DIRS = {".git", "site", ".venv", "node_modules", "__pycache__", ".github"}

# A fenced code block, opened or closed. The pages that DOCUMENT this mechanism
# (README.md, CONTRIBUTING.md) show the markers inside a fence; those are
# examples, not blocks to fill.
FENCE = re.compile(r"^[ \t]*(?P<f>`{3,}|~{3,})", re.MULTILINE)


def fenced_spans(text: str) -> list[tuple[int, int]]:
    """Character ranges covered by fenced code blocks."""
    spans: list[tuple[int, int]] = []
    open_at: int | None = None
    open_fence = ""
    for m in FENCE.finditer(text):
        fence = m.group("f")
        if open_at is None:
            open_at, open_fence = m.start(), fence
        elif fence[0] == open_fence[0] and len(fence) >= len(open_fence):
            spans.append((open_at, m.end()))
            open_at = None
    if open_at is not None:
        spans.append((open_at, len(text)))
    return spans


def walk(root: Path):
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for name in filenames:
            yield Path(dirpath) / name


def stem_of(path: Path) -> str:
    """`z_hello_list.prog.abap` -> `z_hello_list`. Everything after the first dot
    is abapGit's object type, not part of the name."""
    return path.name.split(".", 1)[0]


def find_abap(folder: str) -> dict[str, Path]:
    """Map stem -> path for every .abap under a folder with this name.

    Filenames follow **abapGit**: `<name>.<objecttype>.abap`, as in
    `z_hello_list.prog.abap` or `zcl_ballot.clas.abap`. That is not decoration —
    abaplint identifies an object by that infix and silently analyses *zero*
    files without it, so a plainly-named example would sail through CI unchecked.
    It also means an example can be pulled straight into a system with abapGit.
    """
    found: dict[str, Path] = {}
    for path in sorted(walk(REPO)):
        if path.suffix != ".abap" or path.parent.name != folder:
            continue
        if len(path.suffixes) < 2:
            sys.exit(
                f"ERROR: {path.relative_to(REPO)} is not named the abapGit way.\n"
                "Use <name>.<objecttype>.abap — z_hello_list.prog.abap, "
                "zcl_ballot.clas.abap, zif_tabulator.intf.abap.\n"
                "abaplint analyses nothing it cannot type from the filename, and "
                "says so only as '0 file(s) analyzed'."
            )
        stem = stem_of(path)
        if stem in found:
            sys.exit(
                f"ERROR: duplicate example stem {stem!r}\n"
                f"  {found[stem].relative_to(REPO)}\n  {path.relative_to(REPO)}\n"
                "Stems are named bare in Markdown blocks, so they must be unique."
            )
        found[stem] = path
    return found


def read_key(src: Path) -> tuple[str, str]:
    """Return (provenance, transcript) for one example, or exit explaining why not.

    The provenance line is mandatory. A transcript with no system behind it is a
    claim rather than a record, and this library's whole promise is the difference.
    """
    key = src.parent / f"{stem_of(src)}.out"
    if not key.exists():
        raise FileNotFoundError(
            f"{src.relative_to(REPO)}: no answer key. Run the program in a real "
            f"system and paste its output into {key.name}, starting with a line "
            "like:\n  #!recorded: A4H/001 · SAP_BASIS 7.58 · SE38 · 2026-08-13"
        )
    lines = key.read_text(encoding="utf-8").split("\n")
    m = PROVENANCE.match(lines[0]) if lines else None
    if not m:
        raise ValueError(
            f"{key.relative_to(REPO)}: first line must record where this ran, e.g.\n"
            "  #!recorded: A4H/001 · SAP_BASIS 7.58 · SE38 · 2026-08-13\n"
            "Nothing in CI can run ABAP, so the file has to say who did."
        )
    return m.group("where"), "\n".join(lines[1:]).strip("\n")


def rendered_block(kind: str, src: Path, where: str, transcript: str, page: Path) -> str:
    """The generated body that goes between the markers on `page`."""
    href = os.path.relpath(src, page.parent)
    if kind == "snippet":
        body = src.read_text(encoding="utf-8").strip("\n")
        return (
            f"\n*[`{src.name}`]({href}) — pasted here by `tools/check_examples.py`. "
            "**Syntax-checked, never run:** abaplint parses and type-checks it "
            "against the release in "
            "[`abaplint.json`](https://github.com/masiarek/abap-learning-library/blob/master/abaplint.json)"
            ", but no system has produced output for it, so this page shows none.*\n\n"
            f"```abap\n{body}\n```\n"
        )
    if kind == "source":
        body = src.read_text(encoding="utf-8").strip("\n")
        return (
            f"\n*[`{src.name}`]({href}) in full — pasted here by "
            f"`tools/check_examples.py` from the file the output below came from.*\n\n"
            f"```abap\n{body}\n```\n"
        )
    return (
        f"\n*Recorded output of [`{src.name}`]({href}) — run on {where}, "
        f"pasted here by `tools/check_examples.py`, never hand-typed.*\n\n"
        f"```text\n{transcript}\n```\n"
    )


def fill_pages(
    keys: dict[str, tuple[str, str]],
    sources: dict[str, Path],
    write: bool,
    problems: list[str],
    only: set[str] | None = None,
) -> list[str]:
    """Refill every generated block on every Markdown page. Returns what drifted.

    A block naming an unknown stem is recorded in `problems` and left untouched
    rather than exiting on the spot — dying on the first one would leave every
    other page unfilled.
    """
    drift: list[str] = []
    for page in sorted(walk(REPO)):
        if page.suffix != ".md":
            continue
        text = page.read_text(encoding="utf-8")
        if not any(f"<!-- {kind}:" in text for kind in ("output", "source", "snippet")):
            continue
        skip = fenced_spans(text)

        def replace(m: re.Match) -> str:
            if any(lo <= m.start() < hi for lo, hi in skip):
                return m.group(0)  # documentation, not a block to fill
            stem, kind = m.group("stem"), m.group("kind")
            if only is not None and stem not in only:
                return m.group(0)
            if stem not in sources:
                problems.append(
                    f"{page.relative_to(REPO)}: asks for {kind} block {stem!r}, but no "
                    "examples/*.abap or snippets/*.abap has that stem"
                )
                return m.group(0)
            is_snippet = sources[stem].parent.name == "snippets"
            if is_snippet != (kind == "snippet"):
                # The two folders carry different promises; a block must name the
                # one its program actually lives in, or the caption would lie.
                problems.append(
                    f"{page.relative_to(REPO)}: {kind} block {stem!r} points at "
                    f"{sources[stem].relative_to(REPO)}. A snippets/ program was "
                    "never run, so it can only fill a `snippet:` block; an "
                    "examples/ program has a transcript and cannot fill one."
                )
                return m.group(0)
            if kind != "snippet" and stem not in keys:
                problems.append(
                    f"{page.relative_to(REPO)}: asks for {kind} block {stem!r}, but "
                    "that example has no readable answer key"
                )
                return m.group(0)
            where, transcript = keys.get(stem, ("", ""))
            return (
                m.group("open")
                + rendered_block(kind, sources[stem], where, transcript, page)
                + m.group("close")
            )

        new = BLOCK.sub(replace, text)
        if new != text:
            drift.append(str(page.relative_to(REPO)))
            if write:
                page.write_text(new, encoding="utf-8")
    return drift


def orphan_keys(examples: dict[str, Path]) -> list[str]:
    """`.out` files with no `.abap` beside them — a rename that lost its program."""
    kept = {src.parent / f"{stem_of(src)}.out" for src in examples.values()}
    return [
        str(p.relative_to(REPO))
        for p in sorted(walk(REPO))
        if p.suffix == ".out" and p.parent.name == "examples" and p not in kept
    ]


def keyed_snippets(snippets: dict[str, Path]) -> list[str]:
    """A transcript inside snippets/ — the one thing that folder must never hold.

    `snippets/` means "nobody ran this". A `.out` there is either a real run
    filed in the wrong folder (move the pair to examples/ and the page gains an
    output block) or a transcript with no run behind it, which is the single
    failure this library exists to make impossible.
    """
    return [
        f"{src.parent.relative_to(REPO)}/{stem}.out: a transcript in snippets/. "
        "snippets/ is for programs nobody has run; move the program and its key "
        "to examples/ instead."
        for stem, src in sorted(snippets.items())
        if (src.parent / f"{stem}.out").exists()
    ]


def resolve_selection(raw: list[str], examples: dict[str, Path]) -> set[str]:
    """Turn `--only` values into stems: a bare stem, a path, or the lesson folder."""
    wanted: set[str] = set()
    unknown: list[str] = []
    for token in (t.strip() for value in raw for t in value.split(",")):
        if not token:
            continue
        as_path = Path(token)
        for candidate in (token, stem_of(as_path), as_path.stem, as_path.name):
            if candidate in examples:
                wanted.add(candidate)
                break
        else:
            unknown.append(token)
    if unknown:
        sys.exit(
            f"ERROR: --only names no such example: {', '.join(unknown)}\n"
            f"Known stems: {', '.join(sorted(examples)) or '(none yet)'}"
        )
    return wanted


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--check", action="store_true", help="write nothing; fail on drift (CI)")
    ap.add_argument(
        "--only",
        action="append",
        metavar="STEM[,STEM…]",
        help="restrict to these example stems (a path or the lesson folder works "
        "too); repeat or comma-separate. Everything else is left untouched.",
    )
    args = ap.parse_args()

    examples = find_abap("examples")
    snippets = find_abap("snippets")
    clash = sorted(set(examples) & set(snippets))
    if clash:
        sys.exit(
            "ERROR: same stem in both examples/ and snippets/: "
            + ", ".join(clash)
            + "\nA Markdown block names a bare stem, so one stem is one program."
        )
    sources = {**examples, **snippets}
    if not sources:
        print("No programs found (looked for *.abap under examples/ or snippets/).")
        return 0

    selected = resolve_selection(args.only, sources) if args.only else None

    keys: dict[str, tuple[str, str]] = {}
    failures: list[str] = orphan_keys(examples) + keyed_snippets(snippets)

    for stem, src in examples.items():
        if selected is not None and stem not in selected:
            continue
        try:
            keys[stem] = read_key(src)
        except (FileNotFoundError, ValueError) as exc:
            failures.append(str(exc))
            continue
        print(f"  ok        {src.relative_to(REPO)}  ({keys[stem][0]})")

    for stem, src in snippets.items():
        if selected is not None and stem not in selected:
            continue
        print(f"  unrun     {src.relative_to(REPO)}  (syntax-checked only)")

    drift = fill_pages(keys, sources, write=not args.check, problems=failures, only=selected)

    if args.check and drift:
        failures.append(
            "Markdown blocks are stale: " + ", ".join(drift)
            + " — run tools/check_examples.py"
        )
    elif drift:
        for page in drift:
            print(f"  filled    {page}")

    if failures:
        print("\nFAILED:")
        for f in failures:
            print(f"  - {f}")
        return 1

    if selected is not None:
        print(
            f"\n{len(selected)} of {len(sources)} program(s) checked. --only was in "
            "effect; everything else was left untouched. Do a full run before committing."
        )
        return 0

    print(
        f"\n{len(examples)} example(s) match their recorded output; "
        f"{len(snippets)} snippet(s) carry no output claim."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
