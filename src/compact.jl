function compact_table!(table::CleanTable; empty_values::Vector=[])
    return compact_columns!(compact_rows!(table))
end

function compact_table(table; empty_values::Vector=[])
    return compact_table!(CleanTable(table), empty_values=empty_values)
end

function compact_columns!(table::CleanTable; empty_values::Vector=[])
    filter!(x -> _is_not_empty_col(x, empty_values=empty_values), cols(table))
end

function compact_columns(table; empty_values::Vector=[])
    return compact_columns!(CleanTable(table), empty_values=empty_values)
end

function _is_not_empty_col(col; empty_values::Vector=[])
    for el in skipmissing(col)
        isempty(empty_values) && return true

        !in(el, empty_values) && return true
    end
    
    return false
end

function compact_rows!(table::CleanTable; empty_values::Vector=[])
    
end

function compact_rows(table; empty_values::Vector=[])
    return compact_rows!(CleanTable(table), empty_values=empty_values)
end
