using Tables: materializer

function compact_table_ROT(table; empty_values::Vector=[])
    return materializer(table)(compact_table(table; empty_values))
end

function compact_columns_ROT(table; empty_values::Vector=[])
    return materializer(table)(compact_columns(table; empty_values))
end

function compact_rows_ROT(table; empty_values::Vector=[])
    return materializer(table)(compact_rows(table; empty_values))
end

function delete_const_columns_ROT(table)
    return materializer(table)(delete_const_columns(table))
end

function polish_names_ROT(table; style::Symbol=:snake_case)
    return materializer(table)(polish_names(table; style=style))
end

function reinfer_schema_ROT(table; max_types::Int=3)
    return materializer(table)(reinfer_schema(table; max_types=max_types))
end

function row_as_names_ROT(table, i::Int; remove::Bool=true)
    return materializer(table)(row_as_names(table, i; remove=remove))
end
