import Tables

mutable struct CleanTable <: Tables.AbstractColumns
    names::Vector{Symbol}
    cols::Vector{AbstractVector}
end

_getvector(x::AbstractVector) = x
_getvector(x) = collect(x)

function CleanTable(x)
    names = [Symbol(name) for name in Tables.columnnames(x)]
    cols::Vector{AbstractVector} = AbstractVector[_getvector(Tables.getcolumn(x, name)) for name in names]

    return CleanTable(names, cols)
end

Tables.istable(::Type{<:CleanTable}) = true

names(ct::CleanTable) = getfield(ct, :names)
cols(ct::CleanTable) = getfield(ct, :cols)

Tables.schema(ct::CleanTable) = Tables.Schema(names(ct), [eltype(col) for col in cols(ct)])

Tables.columnaccess(::Type{<:CleanTable}) = true
Tables.columns(ct::CleanTable) = ct
Tables.getcolumn(ct::CleanTable, i::Int) = getindex(cols(ct), i)
Tables.getcolumn(ct::CleanTable, name::Symbol) = getindex(cols(ct), findfirst(isequal(name), names(ct)))
Tables.getcolumn(ct::CleanTable, ::Type{T}, i::Int, nm::Symbol) where {T} = getindex(cols(ct), i)
Tables.columnnames(ct::CleanTable) = names(ct)

Tables.materializer(ct::CleanTable) = CleanTable
