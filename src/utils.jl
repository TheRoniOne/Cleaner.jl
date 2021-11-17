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

    known_rows = _to_known_rows(to_check)

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

function level_distribution(table, columns::Vector{Symbol}; round_digits=3)
    return level_distribution(
        CleanTable(table; copycols=false), columns; round_digits=round_digits
    )
end

function level_distribution(table::CleanTable, column_names::Vector{Symbol}; round_digits=3)
    !issubset(column_names, names(table)) &&
        error("All column names specified must exist in the table")

    to_check = [getproperty(table, col) for col in column_names]

    known_rows = _to_known_rows(to_check)

    row_percent = Dict{Vector{Any},Float64}()

    total = length(cols(table)[1])
    for (row, indexes) in pairs(known_rows)
        get!(row_percent, row, round(length(indexes) / total; digits=round_digits))
    end

    row_percent = sort(collect(row_percent); by=x -> x[2])
    row = map(x -> x[1], row_percent)
    percent = map(x -> x[2], row_percent)

    return CleanTable([:value, :percent], [row, percent])
end

function compare_table_columns(tables...)
    #TODO
end

function _to_known_rows(to_check)
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

    known_rows = Dict{Vector{Any},Vector{Int}}()
    for i in 1:nrows
        indexes = get!(known_rows, rows[i], [i])
        if indexes != [i]
            push!(indexes, i)
        end
    end

    return known_rows
end
