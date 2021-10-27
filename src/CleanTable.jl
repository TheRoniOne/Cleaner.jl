import Tables
import Base: show, setproperty!
using PrettyTables

"""
    CleanTable <: Tables.AbstractColumns

A Tables.jl implementation that stores column names and columns for Cleaner.jl internal use.

The default behavior of this type is to try to copy the columns of the original Tables
implementation a.k.a: the source, but the user can call the second constructor specifiying
`copycols=false` to override this behavior and try to use the original columns directly.
If the source column type is not mutable, it might end up in errors.

# Constructors
```julia
CleanTable(names::Vector{Symbol}, cols; copycols::Bool=false)
CleanTable(table; copycols::Bool=true)
CleanTable(table::CleanTable; copycols::Bool=true)
```
"""
mutable struct CleanTable <: Tables.AbstractColumns
    names::Vector{Symbol}
    cols::Vector{AbstractVector}

    function CleanTable(names::Vector{Symbol}, cols; copycols::Bool=false)
        length(names) != length(cols) && error("Inconsistent length between names given and
        amount of columns")

        nrow = length(cols[1])
        for col in cols
            nrow != length(col) && error("All columns must be of the same length")
        end

        if copycols
            if Threads.nthreads() > 1 && length(names) > 1 && nrow >= 1_000_000
                copied_cols = Vector{AbstractVector}(undef, length(names))

                Threads.@threads for i in 1:length(cols)
                    copied_cols[i] = copy(cols[i])
                end

                return new(copy(names), copied_cols)
            end

            return new(copy(names), [copy(col) for col in cols])
        else
            return new(names, cols)
        end
    end
end

_getvector(x::AbstractVector) = x
_getvector(x) = collect(x)

function CleanTable(table; copycols::Bool=true)
    columns = Tables.columns(table)

    names = [Symbol(name) for name in Tables.columnnames(columns)]
    cols = Vector[_getvector(Tables.getcolumn(columns, name)) for name in names]

    return CleanTable(names, cols; copycols=copycols)
end

function CleanTable(table::CleanTable; copycols::Bool=true)
    return CleanTable(names(table), cols(table); copycols=copycols)
end

Tables.istable(::Type{<:CleanTable}) = true

names(ct::CleanTable) = getfield(ct, :names)
cols(ct::CleanTable) = getfield(ct, :cols)

Tables.schema(ct::CleanTable) = Tables.Schema(names(ct), [eltype(col) for col in cols(ct)])

Tables.columnaccess(::Type{<:CleanTable}) = true
Tables.columns(ct::CleanTable) = ct
Tables.getcolumn(ct::CleanTable, i::Int) = getindex(cols(ct), i)
function Tables.getcolumn(ct::CleanTable, name::Symbol)
    return getindex(cols(ct), findfirst(isequal(name), names(ct)))
end
function Tables.getcolumn(ct::CleanTable, ::Type{T}, i::Int, nm::Symbol) where {T}
    return getindex(cols(ct), i)
end
Tables.columnnames(ct::CleanTable) = names(ct)

Tables.materializer(::CleanTable) = CleanTable

Base.show(io::IO, ct::CleanTable) = pretty_table(io, ct)

"""
    size(table::CleanTable)

Returns a tuple containing the number of rows and columns of the given `CleanTable`.
"""
function size(table::CleanTable)
    return (length(cols(table)[1]), length(names(table)))
end

"""
    rename!(ct::CleanTable, names::Vector{Symbol})

Changes in-place the column names of a `CleanTable` to be `names`.
"""
function rename!(ct::CleanTable, names::Vector{Symbol})
    if length(cols(ct)) != length(names)
        error("Inconsistent length between names given and amount of columns")
    end

    setfield!(ct, :names, names)

    return ct
end

"""
    rename(ct::CleanTable, names::Vector{Symbol})

Creates a `CleanTable` with copied columns and changes its column names to be `names`.
"""
function rename(ct::CleanTable, names::Vector{Symbol})
    return rename!(CleanTable(ct), names)
end

function Base.setproperty!(ct::CleanTable, s::Symbol, x::AbstractVector)
    if s in names(ct)
        if length(cols(ct)[1]) == length(x) || length(cols(ct)) == 1
            index = findfirst(x -> isequal(x, s), names(ct))
            cols(ct)[index] = x

            return nothing
        else
            error(
                "Length of the AbstractVector being assigned to column '$s' must be consistent with the length of the rest of columns",
            )
        end
    elseif s == :names
        error(
            "Changing property 'names' directly is unsupported, please use the `rename!` function",
        )
    elseif s == :cols
        error("Property 'cols' cannot be changed")
    else
        error("Property '$s' does not exist")
    end
end

function Base.setproperty!(::CleanTable, ::Symbol, x)
    return error("Value being assigned must be an AbstractVector")
end
