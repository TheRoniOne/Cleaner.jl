# Exploring your table

## Am I seeing double?

Tables can usualy have values in a column or columns that are supposed to be unique, but often are not.
Primary keys from a table in a database are the most common example of this cases.

For when you want to find out what values (or combinations) are being duplicated on your table we have
the `get_all_repeated` function.

```jldoctest explore
julia> using DataFrames: DataFrame

julia> df = DataFrame(:A => ["y", "x", "y"], :B => ["x", "x", "x"]) 
3×2 DataFrame
 Row │ A       B
     │ String  String
─────┼────────────────
   1 │ y       x
   2 │ x       x
   3 │ y       x

julia> get_all_repeated(df, [:A])
┌───────────┬────────┐
│ row_index │      A │
│     Int64 │ String │
├───────────┼────────┤
│         1 │      y │
│         3 │      y │
└───────────┴────────┘


julia> get_all_repeated(df, [:A, :B])
┌───────────┬────────┬────────┐
│ row_index │      A │      B │
│     Int64 │ String │ String │
├───────────┼────────┼────────┤
│         1 │      y │      x │
│         3 │      y │      x │
└───────────┴────────┴────────┘


```

## How much of each?

TODO

## Shouldn't this match?

TODO

