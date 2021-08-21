# Cleaner

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://TheRoniOne.github.io/Cleaner.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://TheRoniOne.github.io/Cleaner.jl/dev)
[![Build Status](https://github.com/TheRoniOne/Cleaner.jl/workflows/CI/badge.svg)](https://github.com/TheRoniOne/Cleaner.jl/actions)
[![Coverage](https://codecov.io/gh/TheRoniOne/Cleaner.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/TheRoniOne/Cleaner.jl)

A toolbox of simple solutions for common data cleaning problems.

Inspired by [janitor](https://github.com/sfirke/janitor) from the R ecosystem. 

With Cleaner.jl you will be able to:
- Easily format column names for any [Tables.jl](https://github.com/JuliaData/Tables.jl) compatible implementation to be unique and fit snake_case or camelCase style.
- Rematerialize your source Tables.jl type as our CleanTable implements the Tables interface too!
