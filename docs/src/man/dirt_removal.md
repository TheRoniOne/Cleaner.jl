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

## One missing, remove em all

A more radical aproach can be taken when desired by using `drop_missing`, `drop_missing!` or
`drop_missing_ROT` to remove all rows where at least one `missing` or `missing_values` has been found.

```jldoctest removal
julia> ct = CleanTable([:A, :B], [[1, missing, 3], ["x", "y", "z"]])
┌─────────┬────────┐
│       A │      B │
│  Int64? │ String │
├─────────┼────────┤
│       1 │      x │
│ missing │      y │
│       3 │      z │
└─────────┴────────┘


julia> drop_missing(ct)
┌────────┬────────┐
│      A │      B │
│ Int64? │ String │
├────────┼────────┤
│      1 │      x │
│      3 │      z │
└────────┴────────┘


```
