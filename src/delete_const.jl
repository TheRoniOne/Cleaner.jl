function delete_const_columns!(table::CleanTable)
    columns = cols(table)
    ndel = 0

    for i in 1:length(columns)
        if _is_const_col(columns[i - ndel])
            deleteat!(columns, i - ndel)
            deleteat!(names(table), i - ndel)
            ndel += 1
        end
    end

    return table
end

function delete_const_columns(table)
    return delete_const_columns!(CleanTable(table))
end

function _is_const_col(col)
    known = []
    missing_found = false

    for el in col
        if !ismissing(el)
            if !in(el, known)
                push!(known, el)
                length(known) + missing_found >= 2 && return false
            end
        else
            length(known) >= 1 && return false

            if !missing_found
                missing_found = true
            end
    end

    return true
end
