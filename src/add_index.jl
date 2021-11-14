function add_index!(table::CleanTable)
    columns = cols(table)
    indexes = collect(1:length(columns[1]))

    insert!(columns, 1, indexes)
    insert!(names(table), 1, :row_index)

    return table
end

function add_index(table)
    return add_index!(CleanTable(table))
end
