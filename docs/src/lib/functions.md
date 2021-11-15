```@meta
CurrentModule = Cleaner
```

# Functions

## Multi-threading support

The following functions will try to use multiple threads if possible when there are at least 2 columns and 1 million rows:

- `CleanTable` constructor when `copycols=true`
- All `compact` functions
- `delete_const_columns`, `delete_const_columns!` and `delete_const_columns_ROT`
- `reinfer_schema`, `reinfer_schema!` and`reinfer_schema_ROT`

## Index

```@index
Pages = ["functions.md"]
```

## Summarize information

```@docs
size
get_all_repeated
```

## Working with column names

```@docs
rename
rename!
rename_ROT
generate_polished_names
polish_names
polish_names!
polish_names_ROT
row_as_names
row_as_names!
row_as_names_ROT
```

## Row/Column removal

```@docs
compact_columns
compact_columns!
compact_columns_ROT
compact_rows
compact_rows!
compact_rows_ROT
compact_table
compact_table!
compact_table_ROT
delete_const_columns
delete_const_columns!
delete_const_columns_ROT
drop_missing
drop_missing!
drop_missing_ROT
```

## Modifiying table schema

```@docs
reinfer_schema
reinfer_schema!
reinfer_schema_ROT
add_index
add_index!
add_index_ROT
```
