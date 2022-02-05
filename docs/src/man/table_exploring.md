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

When you are working with categorical data, you might want to know what percentage of the total each
category is representing.

For those cases we got the `category_distribution` function.

```jldoctest explore
julia> category_distribution(df, [:A])
┌─────────────┬─────────┐
│       value │ percent │
│ Vector{Any} │ Float64 │
├─────────────┼─────────┤
│    Any["y"] │    66.7 │
│    Any["x"] │    33.3 │
└─────────────┴─────────┘


```

More than one column name can be passed in case your category is made of multiple columns.

```jldoctest explore
julia> category_distribution(df, [:A, :B])
┌───────────────┬─────────┐
│         value │ percent │
│   Vector{Any} │ Float64 │
├───────────────┼─────────┤
│ Any["y", "x"] │    66.7 │
│ Any["x", "x"] │    33.3 │
└───────────────┴─────────┘


```

## Shouldn't this match?

TODO

