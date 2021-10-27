```@meta
CurrentModule = Cleaner
```

# Cleaner

### A toolbox of simple solutions for common data cleaning problems.

## Key Features
### With Cleaner.jl you will be able to:
- Format column names to make them unique and fit snake_case or camelCase style.
- Remove rows and columns with different kinds of empty values. e.g: `
missing`, `""`, `"NA"`, `"None"`
- Delete columns filled with just a constant value.
- Use a row as the names of the columns.
- Minimize the amount of element types for each column without making the column of type `Any`.
- Automatically use multiple threads if your data is big enough (and you are running `Julia` with more than 1 thread).
- Rematerialize your original source [Tables.jl](https://github.com/JuliaData/Tables.jl) type, as CleanTable implements the [Tables.jl](https://github.com/JuliaData/Tables.jl) interface too.

## Acknowledgement
Inspired by [janitor](https://github.com/sfirke/janitor) from the R ecosystem.
