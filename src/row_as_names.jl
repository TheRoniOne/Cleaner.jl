"""
    row_as_names!(table::CleanTable, i::Int; remove::Bool=true)

Renames the table using row i as new names and removes in-place all the rows above row i if remove=true.

Default behavior is to remove rows above row i.
"""
function row_as_names!(table::CleanTable, i::Int; remove::Bool=true)
    columns = cols(table)
    new_names = [Symbol(col[i]) for col in columns]
    to_delete = 1:i

    rename!(table, new_names)

    if remove
        for col in columns
            for i in to_delete
                deleteat!(col, 1)
            end
        end
    end
    
    return table
end

"""
    row_as_names(table, i::Int; remove::Bool=false)

Creates a CleanTable with copied columns and renames the table using row i as new names and removes 
in-place all the rows above row i if remove=true.

Default behavior is to remove rows above row i.
"""
function row_as_names(table, i::Int; remove::Bool=true)
    return row_as_names!(CleanTable(table), i, remove=remove)
end
