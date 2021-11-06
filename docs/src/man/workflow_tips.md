# Workflow tips

## Starting the workflow

Usually you will start by having a Tables.jl implementation loaded with the data you want to work with, so your
next step could be to use a non-mutating `Cleaner` function to start your `Cleaner` workflow.

"""jldoctest start
julia> using DataFrames: DataFrame

julia> using Cleaner

julia> df = DataFrame(" Some bad Name" => [missing, missing, missing], "Another_weird name " => [1, "x", 3])
3×2 DataFrame
 Row │  Some bad Name  Another_weird name
     │ Missing         Any
─────┼─────────────────────────────────────
   1 │        missing  1
   2 │        missing  x
   3 │        missing  3

julia> ct = polish_names(df)
┌───────────────┬────────────────────┐
│ some_bad_name │ another_weird_name │
│       Missing │                Any │
├───────────────┼────────────────────┤
│       missing │                  1 │
│       missing │                  x │
│       missing │                  3 │
└───────────────┴────────────────────┘


"""

After that, you can decide whether to continue using non-mutating functions or start using mutating ones.
"""jldoctest
julia> ct |> compact_columns |> reinfer_schema
┌────────────────────┐
│ another_weird_name │
│   U{Int64, String} │
├────────────────────┤
│                  1 │
│                  x │
│                  3 │
└────────────────────┘


julia> ct
┌───────────────┬────────────────────┐
│ some_bad_name │ another_weird_name │
│       Missing │                Any │
├───────────────┼────────────────────┤
│       missing │                  1 │
│       missing │                  x │
│       missing │                  3 │
└───────────────┴────────────────────┘


julia> ct |> compact_columns! |> reinfer_schema!
┌────────────────────┐
│ another_weird_name │
│   U{Int64, String} │
├────────────────────┤
│                  1 │
│                  x │
│                  3 │
└────────────────────┘


julia> ct
┌────────────────────┐
│ another_weird_name │
│   U{Int64, String} │
├────────────────────┤
│                  1 │
│                  x │
│                  3 │
└────────────────────┘


"""

Depending on what you are trying to do, one could be a better option than the other. For example,
if you need to keep copies of the data in order to do different transformations between copies, using non-mutating
functions would be a better fit, whereas if you just want to do a series of linear transformations on your data and
continue processing it after finishing the cleaning, using mutating functions would a better option.

You could also mix and match mutating and non-mutating `Cleaner` functions to better fit your needs, as all
non-mutating `Cleaner` functions work on any Tables.jl implementation and return a `CleanTable`, while
all mutating `Cleaner` functions work on a `CleanTable` and return a `CleanTable` which also is a Tables.jl
implementation.

There is also the option to build a `CleanTable` from any Tables.jl implementation to start a your workflow by mutating
even the data stored in the original table, as the `CleanTable` constructor has a keyword argument `copycols` that can be
set to false to use the original columns directly at your own risk.

"""jldoctest start
julia> ct = CleanTable(df; copycols=false) |> polish_names! |> compact_columns!
┌────────────────────┐
│ another_weird_name │
│                Any │
├────────────────────┤
│                  1 │
│                  x │
│                  3 │
└────────────────────┘


julia> ct.another_weird_name[2] = 4
4

julia> ct
┌────────────────────┐
│ another_weird_name │
│                Any │
├────────────────────┤
│                  1 │
│                  4 │
│                  3 │
└────────────────────┘


julia> df
3×2 DataFrame
 Row │  Some bad Name  Another_weird name
     │ Missing         Any
─────┼─────────────────────────────────────
   1 │        missing  1
   2 │        missing  4
   3 │        missing  3

"""

The complete oposite approach would be to use a function from the ROT (returning original type) variants (e.g. polish_names_ROT)
that take as input any table, does it's transformation on a copy of it and then returns a new table of the same type of
the source table.

"""jldoctest start
julia> df |> polish_names_ROT
3×2 DataFrame
 Row │ some_bad_name  another_weird_name
     │ Missing        Any
─────┼───────────────────────────────────
   1 │       missing  1
   2 │       missing  4
   3 │       missing  3

"""

## Looking for performance

TODO

## Looking for convenience

TODO
