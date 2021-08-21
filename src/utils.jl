function row_as_names!(table::CleanTable, i::Int; remove::Bool=true)
    # check if all values from row i are acceptable as new names can be converted to Symbols
    columns = cols(table)

    for col in columns
        
    end
end

function row_as_names(table, i::Int)
    return row_as_names!(CleanTable(table), i)
end

function reinfer_schema!(table::CleanTable)
    #narrowtyoes
end

function reinfer_schema(table)
    return reinfer_schema!(CleanTable(table))
end
