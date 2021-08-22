# Cleaner

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://TheRoniOne.github.io/Cleaner.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://TheRoniOne.github.io/Cleaner.jl/dev)
[![Build Status](https://github.com/TheRoniOne/Cleaner.jl/workflows/CI/badge.svg)](https://github.com/TheRoniOne/Cleaner.jl/actions)
[![Coverage](https://codecov.io/gh/TheRoniOne/Cleaner.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/TheRoniOne/Cleaner.jl)

### A toolbox of simple solutions for common data cleaning problems.

**Compatible with any [Tables.jl](https://github.com/JuliaData/Tables.jl) implementation.**

*Inspired by [janitor](https://github.com/sfirke/janitor) from the R ecosystem.*

**Installation**: at the Julia REPL, `using Pkg; Pkg.add("Cleaner")`

## Key Features
### With Cleaner.jl you will be able to:
- Format column names to make them unique and fit snake_case or camelCase style.
- Remove rows and columns with different kinds of empty values. 
<br>e.g: ```
missing, "", "NA", "None"```
- Delete columns filled with just a constant value.
- Use a row as the names of the columns.
- Minimize the amount of element types for each column without making the column type ```Any```.
- Rematerialize your original source [Tables.jl](https://github.com/JuliaData/Tables.jl) type, as CleanTable implements the [Tables.jl](https://github.com/JuliaData/Tables.jl) interface too.
