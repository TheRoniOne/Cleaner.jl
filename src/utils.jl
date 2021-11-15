"""
    get_all_repeated(table, columns::Vector{Symbol})

Returns a `CleanTable` with row indexes containing only the selected columns and keeping
only the rows that were repeated.
"""
function get_all_repeated(table, columns::Vector{Symbol})
    return get_all_repeated(CleanTable(table; copycols=false), columns)
end

function get_all_repeated(table::CleanTable, column_names::Vector{Symbol})
    !issubset(column_names, names(table)) &&
        error("All column names specified must exist in the table")

    to_check = [getproperty(table, col) for col in column_names]
    nrows = length(to_check[1])
    ncols = length(to_check)
    rows = [Vector{Any}(undef, ncols) for _ in 1:nrows]

    for i in 1:ncols
        if Threads.nthreads() > 1 && ncols > 1 && nrows >= 1_000_000
            Threads.@threads for j in 1:nrows
                rows[j][i] = to_check[i][j]
            end
        else
            for j in 1:nrows
                rows[j][i] = to_check[i][j]
            end
        end
    end

    known_rows = Dict{Vector{Any}, Vector{Int}}()
    for i in 1:nrows
        indexes = get!(known_rows, rows[i], [i])
        if indexes != [i]
            push!(indexes, i)
        end
    end

    new_cols = Any[similar(col, 0) for col in to_check]
    index_list = Int[]

    for (row, indexes) in pairs(known_rows)
        if length(indexes) > 1
            push!(index_list, indexes...)

            for i in 1:length(row)
                push!(new_cols[i], [row[i] for _ in indexes]...)
            end
        end
    end

    if length(new_cols[1]) == 0
        @info "No repeated rows were found"
    end

    insert!(new_cols, 1, index_list)
    new_names = copy(column_names)
    insert!(new_names, 1, :row_index)

    return CleanTable(new_names, new_cols)
end

function categorical_distribution(table)
    #TODO
end

function compare_table_columns(table)
    #TODO
end
