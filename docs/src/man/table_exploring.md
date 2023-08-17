# Exploring your table

## Am I seeing double?

Tables can usually have values in a column or columns that are supposed to be unique, but often are not.
Primary keys from a table in a database are the most common example of this cases.

For when you want to find out what values (or combinations) are being duplicated on your table we have
the [`get_all_repeated`](@ref) function.

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

julia> using Cleaner

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

For those cases we got the [`category_distribution`](@ref) function.

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

When working with multiple tables you might try to do joins and have them fail
because there were different column names or schemas between them.

To help you identify these problems we got the [`compare_table_columns`](@ref) function.

```jldoctest explore
julia> df = DataFrame(:A => ["y", "x", "y"], :B => ["x", "x", "x"])
3×2 DataFrame
 Row │ A       B
     │ String  String
─────┼────────────────
   1 │ y       x
   2 │ x       x
   3 │ y       x

julia> df2 = DataFrame(:A => ["y", "x", "y"], :B => [1, 2, 3], :C => [4.0, 5.0, 6.0])
3×3 DataFrame
 Row │ A       B      C
     │ String  Int64  Float64
─────┼────────────────────────
   1 │ y           1      4.0
   2 │ x           2      5.0
   3 │ y           3      6.0

julia> compare_table_columns(df, df2)
┌─────────────┬─────────┬─────────┐
│ column_name │    tbl1 │    tbl2 │
│      Symbol │    Type │    Type │
├─────────────┼─────────┼─────────┤
│           A │  String │  String │
│           B │  String │   Int64 │
│           C │ Nothing │ Float64 │
└─────────────┴─────────┴─────────┘


```

You can pass any number of tables to compare and its number of rows can be different between
each and the other.

```jldoctest explore
julia> df3 = DataFrame(:D => [:x])
1×1 DataFrame
 Row │ D
     │ Symbol
─────┼────────
   1 │ x

julia> compare_table_columns(df, df2, df3)
┌─────────────┬─────────┬─────────┬─────────┐
│ column_name │    tbl1 │    tbl2 │    tbl3 │
│      Symbol │    Type │    Type │    Type │
├─────────────┼─────────┼─────────┼─────────┤
│           A │  String │  String │ Nothing │
│           B │  String │   Int64 │ Nothing │
│           C │ Nothing │ Float64 │ Nothing │
│           D │ Nothing │ Nothing │  Symbol │
└─────────────┴─────────┴─────────┴─────────┘


```
