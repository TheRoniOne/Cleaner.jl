"""
    add_index!(table::CleanTable)
Adds in-place a column being the row index for the `CleanTable` table.
"""
function add_index!(table::CleanTable)
    columns = cols(table)
    indexes = collect(1:length(columns[1]))

    insert!(columns, 1, indexes)
    insert!(names(table), 1, :row_index)

    return table
end

"""
    add_index(table)
Creates a `CleanTable` with copied columns and adds to it a new column being the row index
for the table passed.
"""
function add_index(table)
    return add_index!(CleanTable(table))
end
