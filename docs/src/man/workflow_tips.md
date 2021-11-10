# Workflow tips

## Starting the workflow

Usually you will start by having a [Tables.jl](https://github.com/JuliaData/Tables.jl) implementation loaded with the data you want to work with, so your
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
non-mutating `Cleaner` functions work on any [Tables.jl](https://github.com/JuliaData/Tables.jl) implementation and return a `CleanTable`, while
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

When trying to avoid most of the extra allocations while working with `Cleaner`, you should start by creating a `CleanTable`
specifying `copycols=false` to use the original columns directly on the new `CleanTable` instead of having a non-mutating `Cleaner`
function making copies of them to use on the `CleanTable` it builds first.

```jldoctest performance; setup = :(using Cleaner)
julia> nt = (A = [missing, missing, missing], B = [4, 'x', 6])
(A = [missing, missing, missing], B = Any[4, 'x', 6])

julia> ct = CleanTable(nt; copycols=false)
┌─────────┬─────┐
│       A │   B │
│ Missing │ Any │
├─────────┼─────┤
│ missing │   4 │
│ missing │   x │
│ missing │   6 │
└─────────┴─────┘


```

Now that you have a `CleanTable` you should continue by using `Cleaner` mutating functions, as they will modify the same `CleanTable`
passed as input in place avoiding having to allocate new `CleanTable`s while also avoiding copying the underlying columns data.

```jldoctest performance
julia> compact_columns!(ct)
┌─────┐
│   B │
│ Any │
├─────┤
│   4 │
│   x │
│   6 │
└─────┘


julia> row_as_names!(ct, 2)
┌─────┐
│   x │
│ Any │
├─────┤
│   6 │
└─────┘


julia> ct
┌─────┐
│   x │
│ Any │
├─────┤
│   6 │
└─────┘


julia> nt
(A = [missing, missing, missing], B = Any[6])

```

!!! warning
    Note that when using the original columns to build a `CleanTable` and using mutating functions in it, the changes also happen on
    the source potentially corrupting it.
    
    If you do need to use the original source after applying mutating `Cleaner` functions, you can always just use a non-mutating 
    `Cleaner` function first to have it create a `CleanTable` with copied columns first and do its transformation on it and then 
    continue by using mutating `Cleaner` functions for performance.

## Looking for convenience

TODO

## Final touches

TODO
