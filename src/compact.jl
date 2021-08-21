function compact_table!(table::CleanTable; empty_values::Vector=[])
    return compact_columns!(compact_rows!(table))
end

function compact_table(table; empty_values::Vector=[])
    return compact_table!(CleanTable(table), empty_values=empty_values)
end

function compact_columns!(table::CleanTable; empty_values::Vector=[])
    columns = cols(table)
    ndel = 0

    for i in 1:length(columns)
        if _is_empty_col(columns[i - ndel], empty_values=empty_values)
            deleteat!(columns, i - ndel)
            deleteat!(names(table), i - ndel)
            ndel += 1
        end
    end
end

function compact_columns(table; empty_values::Vector=[])
    return compact_columns!(CleanTable(table), empty_values=empty_values)
end

function _is_empty_col(col; empty_values::Vector=[])
    for el in skipmissing(col)
        isempty(empty_values) && return false

        !in(el, empty_values) && return false
    end
    
    return true
end

function compact_rows!(table::CleanTable; empty_values::Vector=[])
    columns = cols(table)
    lcol = length(col)
    row_state = replace!(Vector{Bool}(undef, lcol), true => false)
    
    for col in columns
        i = 1
        while !row_state[i] && i <= lcol
            if !ismissing(col[i]) && !in(col[i], empty_values)
                row_state[i] = true
            end
            i += 1
        end
    end

    to_delete = findall(!, row_state)
    for col in columns
        map(x -> deleteat!(col, x), to_delete)
    end
end

function compact_rows(table; empty_values::Vector=[])
    return compact_rows!(CleanTable(table), empty_values=empty_values)
end
