"""Build-time fixes that would otherwise cost a pinned plugin dependency.

MkDocs derives a sidebar *section* label from the folder name on disk, so
`01_Foundations/` would read as "01 Foundations". The numeric prefix is there to
set reading order in a file listing; it should not be visible in the nav.

Two jobs:

1. **Label sections** — a section takes its README's `# H1`, backticks dropped,
   because that is authored prose ("How long is a string?"). Only a folder with
   no H1 falls back to its name: strip the ordering prefix, turn underscores into
   spaces, and fix the casing of ABAP's many acronyms (`alv_grid` → "ALV grid",
   `open_sql` → "Open SQL").
2. **Order the sections** — `NAV_ORDER` states the intended reading order per
   folder, keyed by folder path, listing children by their on-disk name.

Why order here rather than by renaming files: a filename is a permanent URL.
Renumbering `03_` to `04_` to insert a lesson would move every page after it and
break any link anyone ever saved. Ordering is presentation, so it belongs in the
presentation layer. Unlisted pages keep their alphabetical slot at the bottom, so
adding a page needs no edit here.

Until 2026-09-12 both jobs missed silently. Labels were built from the title
MkDocs had already derived from the folder name, not from the name itself, so
`01_Foundations` reached `clean()` as "01 Foundations" — which `PREFIX`, looking
for `01_`, never matches, and the sidebar showed the prefix this file exists to
hide. And the root was sorted as a copy of the nav's item list, so the root's
`NAV_ORDER` was never applied.
"""

from __future__ import annotations

import re

# Words the naive title-caser gets wrong, plus the acronyms that must stay loud.
# ABAP has more of these than most languages; add to the list rather than
# renaming a folder, which would move a published URL.
FIXUPS = {
    "Vs": "vs",
    "And": "and",
    "Or": "or",
    "The": "the",
    "To": "to",
    "A": "a",
    "In": "in",
    "Of": "of",
    "Abap": "ABAP",
    "Sql": "SQL",
    "Alv": "ALV",
    "Bapi": "BAPI",
    "Badi": "BAdI",
    "Cds": "CDS",
    "Ddic": "DDIC",
    "Rap": "RAP",
    "Amdp": "AMDP",
    "Bopf": "BOPF",
    "Idoc": "IDoc",
    "Oo": "OO",
    "Itab": "internal table",
    "Se38": "SE38",
    "Adt": "ADT",
    "Sap": "SAP",
    "Hana": "HANA",
    "Api": "API",
    "Ui": "UI",
    "Id": "ID",
}

# Reading order per folder path. Children named by on-disk name; anything not
# listed sorts alphabetically after the listed ones.
NAV_ORDER: dict[str, list[str]] = {
    "": [
        "index.md",
        "01_Foundations",
        "02_Keywords",
        "03_Topics",
        "GLOSSARY.md",
    ],
    "01_Foundations": [
        "README.md",
        "how_long_is_a_string",
    ],
    # Grouped the way 02_Keywords/README.md groups them: declaring, building
    # values, choosing, tables, the database, text, errors, objects, screens.
    # Alphabetical would put ASSERT before DATA, which is a reference order and
    # not a reading one.
    "02_Keywords": [
        "README.md",
        "data", "types", "field_symbols", "data_references", "statics", "enum", "ranges", "mesh",
        "value", "for", "reduce", "filter", "corresponding", "let",
        "new", "cast_conv", "string_templates", "boolean_functions", "numeric_functions",
        "case_if", "cond_switch", "case_type_of", "do_while", "check_continue_exit", "leave_and_stop",
        "loop_at", "read_table", "itab_changes", "collect", "sort", "at_new", "describe_lines",
        "select", "db_writes", "with_cte", "open_cursor_fetch", "exec_sql", "commit_work", "authority_check",
        "concatenate_split", "condense_translate_shift", "find_replace", "call_transformation", "open_dataset",
        "try_catch", "retry_resume", "raise_shortdump", "message", "assert", "break_point_log_point",
        "class", "interfaces", "methods", "events", "friends_aliases_abstract",
        "call_function", "get_badi", "enhancement_point",
        "report_events", "parameters_select_options", "submit", "call_transaction", "export_import",
        "call_screen", "write",
        "sy_fields", "get_time",
        "perform_form", "obsolete_declarations", "move_add_compute", "define_macro",
    ],
    "03_Topics": [
        "README.md",
        "types_at_a_glance", "initial_values_and_null", "conversion_and_comparison_rules",
        "internal_tables", "open_sql", "strings_and_text", "dates_and_times",
        "numbers_and_currency", "constructor_expressions", "modern_vs_classic",
        "oo_abap", "exceptions", "abap_unit", "test_doubles", "releases_and_syntax_levels",
        "ddic_and_domains", "conversion_routines", "table_types_and_buffering", "table_maintenance",
        "number_ranges", "change_documents", "cds_views", "amdp_and_code_pushdown", "native_sql",
        "hana_specifics", "rap", "bopf",
        "program_types", "selection_screens", "classic_reports", "alv", "dynpro_screens",
        "web_dynpro_and_legacy_ui", "odata_and_fiori", "forms_and_printing",
        "text_elements_and_translation", "modularization", "enhancements_and_badis",
        "bapis_and_rfc", "idocs", "batch_input", "logical_databases", "workflow",
        "application_log", "json_and_xml", "http_client", "email_from_abap", "file_handling",
        "luw_and_locking", "abap_memory_and_sap_memory", "authorizations", "security",
        "performance", "parallel_processing", "unicode_and_code_pages", "debugging",
        "short_dumps", "atc_and_code_inspector", "clean_abap", "dynamic_programming",
        "regular_expressions",
        "how_abap_runs", "background_jobs", "transports", "packages_and_namespaces",
        "naming_conventions", "documentation_and_pragmas", "tooling_adt_and_se80", "abapgit",
        "standard_classes", "s4hana_custom_code", "abap_cloud", "resources",
    ],
}

# Folder names whose label the word-by-word caser cannot get right.
LABELS: dict[str, str] = {}

PREFIX = re.compile(r"^\d+[_\-]")


def clean(label: str) -> str:
    """`01_Foundations` -> `Foundations`; `alv_grid` -> `ALV grid`."""
    if label in LABELS:
        return LABELS[label]
    label = PREFIX.sub("", label)
    label = label.replace("_", " ").replace("-", " ")
    out = []
    for w in (w for w in label.split() if w):
        titled = w[:1].upper() + w[1:]
        # Keep an explicitly capitalised word (README, ABAP) as the author wrote it.
        out.append(FIXUPS.get(titled, w if w.isupper() else titled))
    return " ".join(out)


def _folder_of(item) -> str:
    """Repo-relative folder path a nav item's children live in."""
    src = None
    if item.is_page:
        src = item.file.src_path
    elif item.is_section and item.children:
        first = item.children[0]
        if first.is_page:
            src = first.file.src_path
        elif first.is_section:
            return ""
    if not src:
        return ""
    return src.rsplit("/", 1)[0] if "/" in src else ""


def _order(items, folder: str) -> None:
    """Sort `items` in place to match NAV_ORDER[folder], then walk deeper."""
    order = NAV_ORDER.get(folder)
    if order:

        def key(item):
            name = None
            if item.is_page:
                name = item.file.src_path.rsplit("/", 1)[-1]
            elif item.is_section and item.children and item.children[0].is_page:
                # A section is named by the folder its index page sits in.
                parts = item.children[0].file.src_path.split("/")
                name = parts[-2] if len(parts) > 1 else None
            if name in order:
                return (0, order.index(name))
            return (1, item.title or "")

        items.sort(key=key)

    for item in items:
        if item.is_section:
            _order(item.children, _folder_of(item))


def _readme_h1(section) -> str:
    """The `# H1` of a section's own README.md, trimmed for a sidebar ("" if none).

    Page titles here are written "<subject> — <what it teaches>", which reads
    right at the top of the page and is far too long down the side of it. The
    em dash is the seam, so the label is the subject: "`LOOP AT` — `INTO`
    copies, `ASSIGNING` does not" becomes "LOOP AT". A title with no em dash
    ("Which release am I writing for?") is already a label and is kept whole.
    """
    for child in section.children:
        if child.is_page and child.file.src_path.rsplit("/", 1)[-1] == "README.md":
            with open(child.file.abs_src_path, encoding="utf-8") as fh:
                for line in fh:
                    if line.startswith("# "):
                        title = line[2:].strip().replace("`", "")
                        subject = title.split(" — ", 1)[0].strip()
                        return subject or title
    return ""


def _label_sections(items) -> None:
    """Title each section from its README's H1, else from its on-disk folder name."""
    for item in items:
        if item.is_section:
            folder = _folder_of(item).rsplit("/", 1)[-1]
            item.title = _readme_h1(item) or (clean(folder) if folder else item.title)
            _label_sections(item.children)


def on_nav(nav, config, files):
    _label_sections(nav.items)
    _order(nav.items, "")
    return nav
