```@meta
CurrentModule = Cleaner
```

# Cleaner

### A toolbox of simple solutions for common data cleaning problems.

## Key Features

### With Cleaner.jl you will be able to:

- Format column names to make them unique and fit `snake_case` or `camelCase` style.
- Remove rows and columns with different kinds of empty values.
e.g: `missing`, `""`, `"NA"`, `"None"`
- Delete columns filled with just a constant value.
- Delete entire rows where at least one missing value was found.
e.g: `missing`, `""`, `"NA"`, `"None"`
- Use a row as the names of the columns.
- Add a row index for your table.
- Minimize the amount of element types for each column without making the column of type `Any`.
- Automatically use multiple threads if your data is big enough (and you are running `Julia` with more than 1 thread).
- Rematerialize your original source [Tables.jl](https://github.com/JuliaData/Tables.jl) type, as `CleanTable` implements the [Tables.jl](https://github.com/JuliaData/Tables.jl) interface too.
- Apply `Cleaner` transformations on your original table implementation and have the resulting table be of the same type as the original.

### To keep in mind

All non mutating functions (those ending without a `!`) recieve a table as argument and return a CleanTable.
All mutating functions (those ending with a `!`) recieve a CleanTable and return a CleanTable.
All returning original type function variants (those ending with ROT) recieve a `table` as argument and return a `table` of the same type of the original.

So you can start your workflow with a non mutating function and continue using mutating ones.
E.g.

```jldoctest
julia> using DataFrames: DataFrame

julia> using Cleaner

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

## Acknowledgement

Inspired by [janitor](https://github.com/sfirke/janitor) from the R ecosystem.
