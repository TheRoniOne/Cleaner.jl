"""
    delete_const_columns!(table::CleanTable)

Removes in-place from a `CleanTable` each column filled with just a constant value.
"""
function delete_const_columns!(table::CleanTable)
    columns = cols(table)
    ndel = 0

    if Threads.nthreads() > 1 && length(columns) > 1 && length(columns[1]) >= 1_000_000
        col_state = replace!(Vector{Bool}(undef, length(columns)), true => false)

        Threads.@threads for i in 1:length(columns)
            if _is_const_col(columns[i])
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
            if _is_const_col(columns[i - ndel])
                deleteat!(columns, i - ndel)
                deleteat!(names(table), i - ndel)
                ndel += 1
            end
        end
    end

    return table
end

"""
    delete_const_columns(table)

Creates a `CleanTable` with copied columns and removes each column filled with just a
constant value.
"""
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
    end

    return true
end
