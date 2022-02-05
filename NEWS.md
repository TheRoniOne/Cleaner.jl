# Cleaner.jl next major release (current master)

- Section "Exploring your table" for the docs

## New functionalities

- Added add_index, add_index! and add_index_ROT functions
- Added get_all_repeated function
- Added level_distribution function
- Added compare_table_columns function

## Improvements

- Now checking if row_as_names is recieving a number greater than the amount of rows in the table

# Cleaner.jl v0.7 Release Notes

## New functionalities

- Added returning original type (ROT) function variants for all `Cleaner` transformations
- Added drop_missing, drop_missing! and drop_missing_ROT functions
- Now exporting materializer function from [Tables.jl](https://github.com/JuliaData/Tables.jl) for user convenience
