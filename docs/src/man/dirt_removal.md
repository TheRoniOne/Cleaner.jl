# Getting the dirt out

## No value, not kept

Adhering to this philosophy, usually we don't want to keep rows or columns filled just with empty
values in our table.
Empty values can quickly become a big problem to handle when they come in different standards
such as `Julia`'s `missing`, `Python`'s `None`, `R`'s `NA` and a diversity of common strings
like `""`, `' '`, etc.

As an easy way to handle this common problems we got the `compact` functions, being them
`compact_table`, `compact_columns` and `compact_rows` with their mutating in-place and ROT variants
i.e. `compact_table!`, `compact_table_ROT` et al.

They all recieve a table as first argument and an optional keyword argument `empty_values`
where you can pass a vector of what you consider being empty values present in your table.
By default `Julia`'s `missing` is always considered an empty value.

```jldoctest removal
julia> using Cleaner

julia> ct = CleanTable([:A, :B, :C], [[missing, missing, missing], [1, missing, 3], ["x", "", "z"]])
┌─────────┬─────────┬────────┐
│       A │       B │      C │
│ Missing │  Int64? │ String │
├─────────┼─────────┼────────┤
│ missing │       1 │      x │
│ missing │ missing │        │
│ missing │       3 │      z │
└─────────┴─────────┴────────┘


julia> compact_columns(ct)
┌─────────┬────────┐
│       B │      C │
│  Int64? │ String │
├─────────┼────────┤
│       1 │      x │
│ missing │        │
│       3 │      z │
└─────────┴────────┘


julia> compact_rows(ct; empty_values=[""])
┌─────────┬────────┬────────┐
│       A │      B │      C │
│ Missing │ Int64? │ String │
├─────────┼────────┼────────┤
│ missing │      1 │      x │
│ missing │      3 │      z │
└─────────┴────────┴────────┘


julia> compact_table(ct; empty_values=[""])
┌────────┬────────┐
│      B │      C │
│ Int64? │ String │
├────────┼────────┤
│      1 │      x │
│      3 │      z │
└────────┴────────┘


```

You might also feel that columns filled with just a constant value are not adding any value
to your table and may prefer to remove them, for those cases we got the `delete_const_columns`,
`delete_const_columns!` and `delete_const_columns_ROT` functions.

```jldoctest removal
julia> ct = CleanTable([:A, :B, :C], [[4, 5, 6], [1, 1, 1], String["7", "8", "9"]])
┌───────┬───────┬────────┐
│     A │     B │      C │
│ Int64 │ Int64 │ String │
├───────┼───────┼────────┤
│     4 │     1 │      7 │
│     5 │     1 │      8 │
│     6 │     1 │      9 │
└───────┴───────┴────────┘


julia> delete_const_columns(ct)
┌───────┬────────┐
│     A │      C │
│ Int64 │ String │
├───────┼────────┤
│     4 │      7 │
│     5 │      8 │
│     6 │      9 │
└───────┴────────┘


```

## Better have something rather than Any

If you have worked with data in `Julia` before, you might have ended up with a column of element
type `Any` more than once. This usually happens when your column has a mix of different types
that can't be promoted or converted to one and other.

Now, the main problem is that element type `Any` doesn't gives us any relevant information about
what is being stored in our column.

```jldoctest
julia> [1, 2.0]
2-element Vector{Float64}:
 1.0
 2.0

julia> ["1", 2.0]
2-element Vector{Any}:
  "1"
 2.0

```

To solve this problem we have the `reinfer_schema`, `reinfer_schema!` and `reinfer_schema_ROT` functions that will try
to make the column of type `Union` with, by default, up to 3 types stored in `Union` while also
internally using `Base.promote_typejoin` on numeric types to reduce the final amount of numeric types.

The optional keyword argument `max_types` can be used to change the maximum amount of types in `Union`
as, if there would be more than `max_types` on the final `Union`, this functions just will give up and
let the column stay with element type `Any`.

```jldcotest reinfer; setup = :(using Cleaner)
julia> ct = CleanTable([:A, :B, :C], [[1, 2, 3, 4], [5, missing, "z", 2.0], ["6", "7", "8", "9"]])
┌─────┬─────────┬─────┐
│   A │       B │   C │
│ Any │     Any │ Any │
├─────┼─────────┼─────┤
│   1 │       5 │   6 │
│   2 │ missing │   7 │
│   3 │       z │   8 │
│   4 │     2.0 │   9 │
└─────┴─────────┴─────┘


julia> reinfer_schema(ct)
┌───────┬──────────────────┬────────┐
│     A │                B │      C │
│ Int64 │ U{Real, String}? │ String │
├───────┼──────────────────┼────────┤
│     1 │                5 │      6 │
│     2 │          missing │      7 │
│     3 │                z │      8 │
│     4 │              2.0 │      9 │
└───────┴──────────────────┴────────┘


julia> reinfer_schema(ct; max_types=2)
┌───────┬─────────┬────────┐
│     A │       B │      C │
│ Int64 │     Any │ String │
├───────┼─────────┼────────┤
│     1 │       5 │      6 │
│     2 │ missing │      7 │
│     3 │       z │      8 │
│     4 │     2.0 │      9 │
└───────┴─────────┴────────┘


```
