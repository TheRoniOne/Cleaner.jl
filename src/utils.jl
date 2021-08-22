function row_as_names!(table::CleanTable, i::Int; remove::Bool=true)
    # check if all values from row i are acceptable as new names can be converted to Symbols
    columns = cols(table)
    new_names = [col[i] for col in columns]
    to_delete = 1:i

    rename!(table, new_names)
    for col in columns
        map(x -> deleteat!(col, x), to_delete) 
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
