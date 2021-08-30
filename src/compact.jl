"""
    compact_table!(table::CleanTable; empty_values::Vector=[])

Removes in-place from a CleanTable all rows and columns filled entirely by ```missing``` and
 empty_values.
"""
function compact_table!(table::CleanTable; empty_values::Vector=[])
    return compact_rows!(
        compact_columns!(table; empty_values=empty_values); empty_values=empty_values
    )
end

"""
    compact_table(table; empty_values::Vector=[])

Creates a CleanTable with copied columns and removes from it all rows and columns filled
entirely by ```missing```
and empty_values.
"""
function compact_table(table; empty_values::Vector=[])
    return compact_table!(CleanTable(table); empty_values=empty_values)
end

"""
    compact_columns!(table::CleanTable; empty_values::Vector=[])

Removes in-place from a CleanTable all columns filled entirely by ```missing``` and
empty_values.
"""
function compact_columns!(table::CleanTable; empty_values::Vector=[])
    columns = cols(table)
    ndel = 0

    if Threads.nthreads() > 1 && length(columns) > 1 && length(columns[1]) >= 1_000_000
        col_state = replace!(Vector{Bool}(undef, length(columns)), true => false)

        Threads.@threads for i in 1:length(columns)
            if _is_empty_col(columns[i]; empty_values=empty_values)
                col_state[i] = true
            end
        end

        to_delete = findall(col_state)
        for j in to_delete
            deleteat!(columns, j - ndel)
            deleteat!(names(table), j - ndel)
            ndel += 1
        end
    else
        for i in 1:length(columns)
            if _is_empty_col(columns[i - ndel]; empty_values=empty_values)
                deleteat!(columns, i - ndel)
                deleteat!(names(table), i - ndel)
                ndel += 1
            end
        end
    end

    return table
end

"""
    compact_columns(table; empty_values::Vector=[])

Creates a CleanTable with copied columns and removes from it all columns filled entirely by
```missing``` and empty_values.
"""
function compact_columns(table; empty_values::Vector=[])
    return compact_columns!(CleanTable(table); empty_values=empty_values)
end

function _is_empty_col(col; empty_values::Vector=[])
    for el in skipmissing(col)
        isempty(empty_values) && return false

        !in(el, empty_values) && return false
    end

    return true
end

"""
    compact_rows!(table::CleanTable; empty_values::Vector=[])

Removes in-place from a CleanTable all rows filled entirely by ```missing``` and
empty_values.
"""
function compact_rows!(table::CleanTable; empty_values::Vector=[])
    columns = cols(table)
    nrows = length(columns[1])
    row_state = replace!(Vector{Bool}(undef, nrows), true => false)

    if Threads.nthreads() > 1 && length(columns) > 1 && length(columns[1]) >= 1_000_000
        Threads.@threads for col in columns
            i = 1

            while i <= nrows
                if !row_state[i] && !ismissing(col[i]) && !in(col[i], empty_values)
                    row_state[i] = true
                end
                i += 1
            end
        end

        to_delete = findall(!, row_state)
        Threads.@threads for col in columns
            for num in 0:(length(to_delete) - 1)
                deleteat!(col, to_delete[num + 1] - num)
            end
        end
    else
        for col in columns
            i = 1

            while i <= nrows
                if !row_state[i] && !ismissing(col[i]) && !in(col[i], empty_values)
                    row_state[i] = true
                end
                i += 1
            end
        end

        to_delete = findall(!, row_state)
        for col in columns
            for num in 0:(length(to_delete) - 1)
                deleteat!(col, to_delete[num + 1] - num)
            end
        end
    end

    return table
end

"""
    compact_rows(table; empty_values::Vector=[])

Creates a CleanTable with copied columns and removes from it all rows filled entirely by
```missing``` and empty_values.
"""
function compact_rows(table; empty_values::Vector=[])
    return compact_rows!(CleanTable(table); empty_values=empty_values)
end
