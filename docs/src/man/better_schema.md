# For a better schema

## Getting row numbers

TODO

## Any type would be better than type Any

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
