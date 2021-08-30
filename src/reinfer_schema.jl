"""
    reinfer_schema!(table::CleanTable; max_types::Int=3)

Tries to minimize the amount of element types for each column without making the column type
```Any```.

For this, will try to make the column of type ```Union``` with up to max_types and
internally use ```Base.promote_typejoin``` on all numeric types.
If not possible, leaves the column as-is.
"""
function reinfer_schema!(table::CleanTable; max_types::Int=3)
    columns = cols(table)
    if Threads.nthreads() > 1 && length(columns) > 1 && length(columns[1]) >= 1_000_000
        Threads.@threads for i in 1:length(columns)
            col = columns[i]
            type = eltype(col)
            if type == Any
                types = Vector{DataType}()
                number_types = Vector{DataType}()

                for T in unique(typeof.(col))
                    if T <: Number
                        push!(number_types, T)
                    else
                        push!(types, T)
                    end
                end

                if !isempty(number_types)
                    push!(types, reduce(Base.promote_typejoin, number_types))
                end

                if length(types) <= max_types
                    columns[i] = convert(AbstractVector{Union{types...}}, col)
                end
            end
        end
    else
        for i in 1:length(columns)
            col = columns[i]
            type = eltype(col)
            if type == Any
                types = Vector{DataType}()
                number_types = Vector{DataType}()

                for T in unique(typeof.(col))
                    if T <: Number
                        push!(number_types, T)
                    else
                        push!(types, T)
                    end
                end

                if !isempty(number_types)
                    push!(types, reduce(Base.promote_typejoin, number_types))
                end

                if length(types) <= max_types
                    columns[i] = convert(AbstractVector{Union{types...}}, col)
                end
            end
        end
    end

    return table
end

"""
    reinfer_schema(table; max_types::Int=3)

Creates a CleanTable with copied columns and tries to minimize the amount of element types
for each column without making the column type ```Any```.

For this, will try to make the column of type ```Union``` with up to max_types and
internally use ```Base.promote_typejoin``` on all numeric types.
If not possible, leaves the column as-is.
"""
function reinfer_schema(table; max_types::Int=3)
    return reinfer_schema!(CleanTable(table); max_types=max_types)
end
