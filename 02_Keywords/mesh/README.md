# `TYPES BEGIN OF MESH` — meshes

**Level:** 301 · deep dive

**Status:** stub — the shape is here; the worked program is not yet.

**One line:** A mesh (7.40) is a structure whose components are internal tables with declared **associations** between them, so that a mesh path — `lo_mesh-orders\items[ ls_order ]` — follows a foreign-key relationship without writing the `READ TABLE` — an elegant idea that almost nobody uses, and that is worth recognising when you meet it.

## The shape

```abap
TYPES: BEGIN OF MESH ty_shop,
         customers TYPE ty_customers ASSOCIATION to_orders TO orders ON customer = id,
         orders    TYPE ty_orders    ASSOCIATION to_items  TO items  ON order    = id,
         items     TYPE ty_items,
       END OF MESH ty_shop.

DATA ls_shop TYPE ty_shop.
" ... fill the three tables ...
LOOP AT ls_shop-customers\to_orders[ ls_customer ] INTO DATA(ls_order).
  " orders of this customer, via the association
ENDLOOP.
```

Associations are declared once, in the type, and every mesh path uses them. Inverse associations (`\^to_orders`) walk the other way; paths chain.

## Why it is on the shelf

Because it is real ABAP, because the same idea — associations declared with the data — is exactly what [CDS views](../../03_Topics/cds_views/README.md) do on the database side, and because a reader meeting `\` in a table expression for the first time has no way to guess what it means. In practice the CDS form won; meshes are rare in shipped code.

## What this page still needs

- [ ] a `snippets/` program with a three-table mesh and a chained path
- [ ] performance: whether a mesh path uses the table keys, measured
- [ ] the mesh forms of `INSERT`, `DELETE` and `MODIFY`

## See also

- [`TYPES` and `CONSTANTS`](../types/README.md) — where a mesh type is declared
- [`READ TABLE` and table expressions](../read_table/README.md) — what a mesh path replaces
- [CDS views](../../03_Topics/cds_views/README.md) — the same idea, on the database
- [Internal tables](../../03_Topics/internal_tables/README.md) — the tables inside the mesh
