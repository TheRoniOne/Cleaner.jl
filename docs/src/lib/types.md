# Types

## CleanTable type design

`CleanTable` is the type where all [Cleaner.jl](https://github.com/TheRoniOne/Cleaner.jl) functions operate. For example, when you call `polish_names(table)` internally a `CleanTable` (ct) with copied columns based in the table passed is being created and `polish_names!(ct)` is called to return the desired result.

By default the constructor that builds a `CleanTable` from a table copies the columns but this behavior can be bypassed by passing the argument `copycols=false` e.g. `CleanTable(table; copycols=false)`.

It is only possible to change column names from a `CleanTable` directly, adding/removing rows or columns without using [Cleaner.jl](https://github.com/TheRoniOne/Cleaner.jl) functions is not supported and heavily discouraged. Please use other packages that support the [Tables.jl](https://github.com/JuliaData/Tables.jl) interface such as [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) for those needs.

## Type specification

```@docs
CleanTable
```
