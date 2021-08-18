import Tables

"""
    CleanTable <: Tables.AbstractColumns

A Tables.jl implementation that stores column names and columns.

*Expected to only be used internally by this package*

# Constructors
```julia
CleanTable(names::Vector{Symbol}, cols::Vector{AbstractVector})
CleanTable(table)
```
"""
mutable struct CleanTable <: Tables.AbstractColumns
    names::Vector{Symbol}
    cols::Vector{AbstractVector}
end

_getvector(x::AbstractVector) = x
_getvector(x) = collect(x)

function CleanTable(table)
    names = [Symbol(name) for name in Tables.columnnames(table)]
    cols = Vector[_getvector(Tables.getcolumn(table, name)) for name in names]

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
