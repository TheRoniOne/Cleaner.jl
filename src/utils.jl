using Tables: schema

"""
    get_all_repeated(table, columns::Vector{Symbol})

Returns a `CleanTable` with row indexes containing only the selected columns and only the
rows that were repeated.
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

"""
    category_distribution(table, columns::Vector{Symbol}; round_digits=1, bottom_prct=0, top_prct=0)

Returns a `CleanTable` only taking into account the selected columns and containing
unique rows and the percentage they represent out of the total rows.
The percentage is rounded with up to `round_digits`.
`bottom_prct` can be specified to have the least represented categories up to `bottom_prct` percentage become `Bottom_other`.
`top_prct` can be specified to have the most represented categories up to `top_prct` percentage become `Top_other`.
"""
function category_distribution(
    table, column_names::Vector{Symbol}; round_digits=1, bottom_prct=0, top_prct=0
)
    return category_distribution(
        CleanTable(table; copycols=false),
        column_names;
        round_digits=round_digits,
        bottom_prct=bottom_prct,
        top_prct=top_prct,
    )
end

function category_distribution(
    table::CleanTable,
    column_names::Vector{Symbol};
    round_digits=1,
    bottom_prct=0,
    top_prct=0,
)
    !issubset(column_names, names(table)) &&
        error("All column names specified must exist in the table")

    bottom_prct + top_prct > 100 &&
        error("The sum of `bottom_prct` and `top_prct` cannot excede 100")

    to_check = [getproperty(table, col) for col in column_names]

    known_rows = _to_known_rows(to_check)

    row_percent = Dict{Any,Float64}()

    total = length(cols(table)[1])
    for (row, indexes) in pairs(known_rows)
        get!(row_percent, row, round(length(indexes) / total * 100; digits=round_digits))
    end

    row_percent = sort(collect(row_percent); by=x -> x[2], rev=true)

    if top_prct > 0
        top = 0
        while !isempty(row_percent) && top + row_percent[1][2] <= top_prct
            top = top + popfirst!(row_percent)[2]
        end
        pushfirst!(row_percent, :Top_other => top)
    end

    if bottom_prct > 0
        bottom = 0
        while !isempty(row_percent) && bottom + row_percent[end][2] <= bottom_prct
            bottom = bottom + pop!(row_percent)[2]
        end
        push!(row_percent, :Bottom_other => bottom)
    end

    row = map(x -> x[1], row_percent)
    percent = map(x -> x[2], row_percent)

    return CleanTable([:value, :percent], [row, percent])
end

"""
    compare_table_columns(tables...; dupe_sanitize=true)

Returns a `CleanTable` comparing all column names and column types from the tables passed.
By default sanitizes duplicated column names when found in the same table but the keyword argument dupe_sanitize=false can be passed to opt-out on this behavior.
"""
function compare_table_columns(tables...; dupe_sanitize=true)
    cts = [CleanTable(table; copycols=false) for table in tables]
    ntables = length(tables)

    schemas = [schema(ct) for ct in cts]

    header = pushfirst!([Symbol("tbl$i") for i in 1:length(tables)], :column_name)
    all_names = Set{Symbol}()
    result = Vector{Dict{Symbol,Type}}(undef, ntables)

    for (i, schema) in enumerate(schemas)
        names = getproperty(schema, :names)

        if dupe_sanitize
            names = _sanitize_dupes(string.(names))
        else
            new_names = Vector{Symbol}()
            dupes = Dict{String,Int64}()

            for name in names
                if !(name in new_names)
                    push!(new_names, name)
                else
                    error(
                        "Duplicated column name '$name' found on table number $i passed. \nPlease use `dupe_sanitize=true`, `polish_names` or sanitize duplicated column names manually",
                    )
                end
            end
        end

        types = getproperty(schema, :types)
        union!(all_names, names)

        names_types = Dict(zip(names, types))

        result[i] = names_types
    end

    columns = Any[Vector{Type}(undef, length(all_names)) for _ in cts]
    all_names = sort(collect(all_names))

    for i in 1:ntables
        for (j, name) in enumerate(all_names)
            columns[i][j] = get(result[i], name, Nothing)
        end
    end

    pushfirst!(columns, all_names)

    return CleanTable(header, columns)
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
