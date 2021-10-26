# First steps

## Installation
Installing the latest stable version of Cleaner is as simple as using
```julia
import Pkg
Pkg.add("Cleaner")
```

After installation has finished, you just need to call `using Cleaner` to get all `Cleaner` functionalities in your current namespace

## About the CleanTable type
A CleanTable is meant to represent data in a tabular format, being column based by design, while also being the type where all `Cleaner` functions do their work.

It implements the [Tables.jl](https://github.com/JuliaData/Tables.jl) interface and the constructor can create a CleanTable from any `Tables.jl` implementation.

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

If the original `Tables.jl` implementation (source) you were using supports constructing the source type from any `Tables.jl` implementation, 
getting back to using an object of your source type is as easy as calling its constructor after you have finished working with `Cleaner`.

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
