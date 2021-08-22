function reinfer_schema!(table::CleanTable, max_types::Int=3)
    columns = cols(table)
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
                columns[i] = convert(Vector{Union{types...}}, col)
            end        
            
        end
    end

    return table
end

function reinfer_schema(table)
    return reinfer_schema!(CleanTable(table))
end
