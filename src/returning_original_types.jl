using Tables: materializer

"""
    compact_table_ROT(table; empty_values::Vector=[])

Returns a new table of the original `table` type where all rows
and columns filled entirely by `missing` and `empty_values` have been removed.
"""
function compact_table_ROT(table; empty_values::Vector=[])
    return materializer(table)(compact_table(table; empty_values))
end

"""
    compact_columns_ROT(table; empty_values::Vector=[])

Returns a new table of the original `table` type where all columns filled entirely by
`missing` and `empty_values` have been removed.
"""
function compact_columns_ROT(table; empty_values::Vector=[])
    return materializer(table)(compact_columns(table; empty_values))
end

"""
    compact_rows_ROT(table; empty_values::Vector=[])

Returns a new table of the original `table` type where all rows filled entirely by
`missing` and `empty_values` have been removed.
"""
function compact_rows_ROT(table; empty_values::Vector=[])
    return materializer(table)(compact_rows(table; empty_values))
end

"""
    delete_const_columns_ROT(table)

Returns a new table of the original `table` type where all columns filled with just a
constant value have been removed.
"""
function delete_const_columns_ROT(table)
    return materializer(table)(delete_const_columns(table))
end

"""
    polish_names_ROT(table; style::Symbol=:snake_case)

Returns a new table of the original `table` type where column names have been replaced to
be unique and formated using the `style` selected.

# Styles
- snake_case
- camelCase
"""
function polish_names_ROT(table; style::Symbol=:snake_case)
    return materializer(table)(polish_names(table; style=style))
end

"""
    reinfer_schema_ROT(table; max_types::Int=3)

Returns a new table of the original `table` type where it has been tried to minimize the
amount of element types for each column without making the column type `Any`.

For this, will try to make the column of type `Union` with up to max_types and
internally use `Base.promote_typejoin` on all numeric types.
If not possible, leaves the column as-is.
"""
function reinfer_schema_ROT(table; max_types::Int=3)
    return materializer(table)(reinfer_schema(table; max_types=max_types))
end

"""
    row_as_names_ROT(table, i::Int; remove::Bool=true)

Returns a new table of the original `table` type that has been renamed using row `i` as
new names and removes in-place all the rows above row `i` if `remove=true`.
"""
function row_as_names_ROT(table, i::Int; remove::Bool=true)
    return materializer(table)(row_as_names(table, i; remove=remove))
end

"""
    rename_ROT(table, names::Vector{Symbol})

Returns a new table of the original `table` type where its column names have been changed
to be `names`.
"""
function rename_ROT(table, names::Vector{Symbol})
    return materializer(table)(rename(table, names))
end

"""
    drop_missing_ROT(table; missing_values::Vector=[])

Returns a new table of the original `table` type where all rows where `missing` or
`missing_values` have been found were removed.
"""
function drop_missing_ROT(table; missing_values::Vector=[])
    return materializer(table)(drop_missing(table; missing_values=missing_values))
end

"""
    add_index_ROT(table)
Returns a new table of the original `table` type where a new column being the row index
for the table passed have been added.
"""
function add_index_ROT(table)
    return materializer(table)(add_index(table))
end
