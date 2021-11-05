"""
    drop_missing!(table::CleanTable; missing_values::Vector=[])

Removes in-place from a `CleanTable` all rows where `missing` or `missing_values` have been
found.
"""
function drop_missing!(table::CleanTable; missing_values::Vector=[])
    columns = cols(table)
    nrows = length(columns[1])
    row_state = replace!(Vector{Bool}(undef, nrows), true => false)

    if Threads.nthreads() > 1 && length(columns) > 1 && length(columns[1]) >= 1_000_000
        Threads.@threads for col in columns
            i = 1

            while i <= nrows
                if !row_state[i] && ismissing(col[i]) || in(col[i], missing_values)
                    row_state[i] = true
                end
                i += 1
            end
        end

        to_delete = findall(row_state)
        Threads.@threads for col in columns
            for num in 0:(length(to_delete) - 1)
                deleteat!(col, to_delete[num + 1] - num)
            end
        end
    else
        for col in columns
            i = 1

            while i <= nrows
                if !row_state[i] && ismissing(col[i]) || in(col[i], missing_values)
                    row_state[i] = true
                end
                i += 1
            end
        end

        to_delete = findall(row_state)
        for col in columns
            for num in 0:(length(to_delete) - 1)
                deleteat!(col, to_delete[num + 1] - num)
            end
        end
    end

    return table
end

"""
    drop_missing(table; missing_values::Vector=[])

Creates a `CleanTable` with copied columns and removes from it all rows where `missing` or
`missing_values` have been found.
"""
function drop_missing(table; missing_values::Vector=[])
    return drop_missing!(CleanTable(table); missing_values=missing_values)
end
