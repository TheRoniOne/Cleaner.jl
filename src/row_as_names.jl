function row_as_names!(table::CleanTable, i::Int; remove::Bool=true)
    columns = cols(table)
    new_names = [Symbol(col[i]) for col in columns]
    to_delete = 1:i

    rename!(table, new_names)

    if remove
        for col in columns
            map(x -> deleteat!(col, x), to_delete) 
        end
    end
    
    return table
end

function row_as_names(table, i::Int)
    return row_as_names!(CleanTable(table), i)
end
