# Functions

## Multi-threading support
The following functions will try to use multiple threads if possible when there are at least 2 columns and 1 million rows:

- `CleanTable` constructor when `copycols=true`
- All `compact` functions
- `delete_const_columns` and `delete_const_columns!`
- `reinfer_schema` and `reinfer_schema!`

## Index
```@index
Pages = ["functions.md"]
```

## Summarize information
```@docs
size
```

## Working with column names
```@docs
generate_polished_names
polish_names
polish_names!
row_as_names
row_as_names!
```

## Row/Column removal
```@docs
compact_columns
compact_columns!
compact_rows
compact_rows!
compact_table
compact_table!
delete_const_columns
delete_const_columns!
```

## Modifiying table schema
```@docs
reinfer_schema
reinfer_schema!
```
