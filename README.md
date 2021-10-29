# Cleaner

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://TheRoniOne.github.io/Cleaner.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://TheRoniOne.github.io/Cleaner.jl/dev)
[![Build Status](https://github.com/TheRoniOne/Cleaner.jl/workflows/CI/badge.svg)](https://github.com/TheRoniOne/Cleaner.jl/actions)
[![Coverage](https://codecov.io/gh/TheRoniOne/Cleaner.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/TheRoniOne/Cleaner.jl)
### A toolbox of simple solutions for common data cleaning problems.

**Compatible with any [Tables.jl](https://github.com/JuliaData/Tables.jl) implementation.**

**Installation**: At the Julia REPL, `using Pkg; Pkg.add("Cleaner")`

## Key Features

### With Cleaner.jl you will be able to:

- Format column names to make them unique and fit `snake_case` or `camelCase` style.
- Remove rows and columns with different kinds of empty values.
e.g: `missing`, `""`, `"NA"`, `"None"`
- Delete columns filled with just a constant value.
- Use a row as the names of the columns.
- Minimize the amount of element types for each column without making the column of type `Any`.
- Automatically use multiple threads if your data is big enough (and you are running `Julia` with more than 1 thread).
- Rematerialize your original source [Tables.jl](https://github.com/JuliaData/Tables.jl) type, as `CleanTable` implements the [Tables.jl](https://github.com/JuliaData/Tables.jl) interface too.

### To keep in mind

All non mutating functions (those ending without a `!`) recieve a `table` as argument and return a `CleanTable`.
All mutating functions (those ending with a `!`) recieve a `CleanTable` and return a `CleanTable`.

So you can start your workflow with a non mutating function and continue it using mutating ones if you prefer.
E.g.

```julia
julia> df = DataFrame(" some bad Name" => [missing, missing, missing], "Another_weird name " => [1, 2, 3])
3×2 DataFrame
 Row │  some bad Name  Another_weird name
     │ Missing         Int64
─────┼─────────────────────────────────────
   1 │        missing                    1
   2 │        missing                    2
   3 │        missing                    3

julia> df |> polish_names |> compact_columns!
┌────────────────────┐
│ another_weird_name │
│              Int64 │
├────────────────────┤
│                  1 │
│                  2 │
│                  3 │
└────────────────────┘


```

## Related Packages

- [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) for general and complex tabular data transformations.
- [TableOperations.jl](https://github.com/JuliaData/TableOperations.jl) for common lazily evaluated transformations on [Tables.jl](https://github.com/JuliaData/Tables.jl) implementations.
- [TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl) for statistical lazily evaluated data transformations on [Tables.jl](https://github.com/JuliaData/Tables.jl) implementations.

## Acknowledgement

Inspired by [janitor](https://github.com/sfirke/janitor) from the R ecosystem.
