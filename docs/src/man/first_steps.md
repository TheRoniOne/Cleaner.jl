# First steps

## Installation

Installing the latest stable version of Cleaner is as simple as using:

```julia
import Pkg
Pkg.add("Cleaner")
```

After installation has finished, you just need to call `using Cleaner` to get all `Cleaner`
functionalities in your current namespace.

## About the CleanTable type

A CleanTable is meant to represent data in a tabular format, being column based by design, while
also being the type where all `Cleaner` functions do their work.

It implements the [Tables.jl](https://github.com/JuliaData/Tables.jl) interface and the constructor
can create a CleanTable from any `Tables.jl` implementation.

```jldoctest cleantable
julia> using DataFrames

julia> df = DataFrame(A = Any[1, 2, 3, 4], B = Any["M", "F", "F", "M"])
4×2 DataFrame
 Row │ A    B
     │ Any  Any
─────┼──────────
   1 │ 1    M
   2 │ 2    F
   3 │ 3    F
   4 │ 4    M

julia> using Cleaner

julia> ct = CleanTable(df)
┌─────┬─────┐
│   A │   B │
│ Any │ Any │
├─────┼─────┤
│   1 │   M │
│   2 │   F │
│   3 │   F │
│   4 │   M │
└─────┴─────┘


```

If the original `Tables.jl` implementation (source) you were using supports constructing the source
type from any `Tables.jl` implementation, getting back to using an object of your source type is as
easy as calling its constructor after you have finished working with `Cleaner`.

```jldoctest cleantable
julia> reinfer_schema!(ct)
┌───────┬────────┐
│     A │      B │
│ Int64 │ String │
├───────┼────────┤
│     1 │      M │
│     2 │      F │
│     3 │      F │
│     4 │      M │
└───────┴────────┘


julia> DataFrame(ct)
4×2 DataFrame
 Row │ A      B
     │ Int64  String
─────┼───────────────
   1 │     1  M
   2 │     2  F
   3 │     3  F
   4 │     4  M

```

All `Cleaner` functions support piping too so the code above could be rewritten as this:

```jldoctest cleantable
julia> df |> CleanTable |> reinfer_schema! |> DataFrame
4×2 DataFrame
 Row │ A      B
     │ Int64  String
─────┼───────────────
   1 │     1  M
   2 │     2  F
   3 │     3  F
   4 │     4  M

```

By default the [`CleanTable`](@ref) constructor when called with a table as only argument will copy the columns
instead of using directly the source columns. This behavior can be overwritten by explicitly passing
the `copycols=false` keyword argument.

```jldoctest cleantable
julia> ct = CleanTable(df)
┌─────┬─────┐
│   A │   B │
│ Any │ Any │
├─────┼─────┤
│   1 │   M │
│   2 │   F │
│   3 │   F │
│   4 │   M │
└─────┴─────┘


julia> ct.A[1] = 5
5

julia> ct
┌─────┬─────┐
│   A │   B │
│ Any │ Any │
├─────┼─────┤
│   5 │   M │
│   2 │   F │
│   3 │   F │
│   4 │   M │
└─────┴─────┘


julia> df
4×2 DataFrame
 Row │ A    B
     │ Any  Any
─────┼──────────
   1 │ 1    M
   2 │ 2    F
   3 │ 3    F
   4 │ 4    M

julia> ct = CleanTable(df; copycols=false)
┌─────┬─────┐
│   A │   B │
│ Any │ Any │
├─────┼─────┤
│   1 │   M │
│   2 │   F │
│   3 │   F │
│   4 │   M │
└─────┴─────┘


julia> ct.A[1] = 5;

julia> ct
┌─────┬─────┐
│   A │   B │
│ Any │ Any │
├─────┼─────┤
│   5 │   M │
│   2 │   F │
│   3 │   F │
│   4 │   M │
└─────┴─────┘


julia> df
4×2 DataFrame
 Row │ A    B
     │ Any  Any
─────┼──────────
   1 │ 5    M
   2 │ 2    F
   3 │ 3    F
   4 │ 4    M

```

## Accessing columns

If you want to access an specific column, [`CleanTable`](@ref) supports access by column index and
column name.

```jldoctest access_cols; setup = :(using Cleaner)
julia> ct = CleanTable([:A, :B], [[1, 2, 3, 4], ["M", "F", "F", "M"]])
┌───────┬────────┐
│     A │      B │
│ Int64 │ String │
├───────┼────────┤
│     1 │      M │
│     2 │      F │
│     3 │      F │
│     4 │      M │
└───────┴────────┘


julia> ct.A
4-element Vector{Int64}:
 1
 2
 3
 4

julia> ct[1]
4-element Vector{Int64}:
 1
 2
 3
 4

```

As the result of accessing a column in a [`CleanTable`](@ref) is the column itself, if you want to reasign
values in a column you can just modify the accessed result.

E.g:

```jldoctest access_cols
julia> ct.A = [5, 6, 7, 8]
4-element Vector{Int64}:
 5
 6
 7
 8

julia> ct
┌───────┬────────┐
│     A │      B │
│ Int64 │ String │
├───────┼────────┤
│     5 │      M │
│     6 │      F │
│     7 │      F │
│     8 │      M │
└───────┴────────┘


```

!!! warning

    Adding/removing rows or columns without using [Cleaner.jl](https://github.com/TheRoniOne/Cleaner.jl) 
    functions is not supported and heavily discouraged. Please refer to other packages such as 
    [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) for those needs.
