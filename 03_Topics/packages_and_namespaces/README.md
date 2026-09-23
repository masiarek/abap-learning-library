# Packages and namespaces — where an object lives, and who may use it

**Level:** 201 · working knowledge

**Status:** stub — the model is here; a worked structure is not yet.

**One line:** Every repository object belongs to a **package** (`SE21`/`SE80`, formerly development class), which decides its transport layer and software component and can declare **package interfaces** that control which objects other packages may use — a modularity mechanism most systems ignore and ABAP Cloud enforces.

## The model

| Concept | Is |
|---|---|
| Package | the folder an object lives in; nests (`ZFIN` → `ZFIN_AR` → `ZFIN_AR_API`) |
| Software component | `HOME` for customer objects; `LOCAL` for `$TMP` and unlisted; decides deliverability |
| Transport layer | `Z<SID>` for customer packages; `$TMP` has none — nothing there can be transported |
| Package interface | the objects a package **exposes**; without one, other packages may use nothing (when checks are on) |
| Use access | a package's permission to use another's interface |
| Package check (`SE80` → Check → Package) | the ATC/inspector check that enforces the two lines above |
| Structure package / main package / sub-package | the hierarchy levels in the classic (non-ABAP Cloud) model |
| Namespace `/ABC/` | a registered prefix; objects in it belong to the namespace's owner and need its key to be changed |

`$TMP` is the local package: objects there are never transported, which makes it right for experiments and wrong for anything a colleague will ever need.

## Why it earns a page

Because the package is the unit of [abapGit](../abapgit/README.md), of the ATC run, of the transport layer and of ABAP Cloud's access control, and because a system where everything is in one `ZDEV` package has no where-used boundary anyone can reason about. The package interface mechanism is the closest thing ABAP has to `public`/`internal` at the module level; ABAP Cloud's *released* state is built on it.

## What this page still needs

- [ ] a package hierarchy for a small application, with one interface and one use access, and the check that fails without them
- [ ] `$TMP` → real package move, and what changes for the transport
- [ ] the ABAP Cloud software component model (`ZLOCAL`, git-based) beside the classic one

## See also

- [Transports](../transports/README.md) — the layer the package decides
- [Naming conventions](../naming_conventions/README.md) — the namespace side
- [ABAP Cloud](../abap_cloud/README.md) — where package interfaces became mandatory
- [abapGit](../abapgit/README.md) — a package as a repository
