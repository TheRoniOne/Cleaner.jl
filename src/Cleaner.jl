module Cleaner

# includes (CleanTable.jl must always be first)
include("CleanTable.jl")
include("polish_names.jl")
include("compact.jl")
include("delete_const.jl")
include("row_as_names.jl")
include("reinfer_schema.jl")

# CleanTable.jl exports
export CleanTable
export size

# polish_names.jl exports
export polish_names!
export polish_names
export generate_polished_names

# compact.jl exports
export compact_table!
export compact_table
export compact_columns!
export compact_columns
export compact_rows!
export compact_rows

# delete_const.jl exports
export delete_const_columns!
export delete_const_columns

# row_as_names.jl exports
export row_as_names!
export row_as_names

# reinfer_schema.jl
export reinfer_schema!
export reinfer_schema

precompile(CleanTable, (Vector{Symbol}, Vector{AbstractVector}))
precompile(polish_names!, (CleanTable,))
precompile(generate_polished_names, (Vector{String},))
precompile(compact_table!, (CleanTable,))
precompile(compact_columns!, (CleanTable,))
precompile(compact_rows!, (CleanTable,))
precompile(delete_const_columns!, (CleanTable,))
precompile(row_as_names!, (CleanTable,))
precompile(reinfer_schema!, (CleanTable,))

end
