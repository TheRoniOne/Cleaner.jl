module Cleaner

# includes (CleanTable.jl must always be first)
include("CleanTable.jl")
include("polish_names.jl")
include("compact.jl")
include("delete_const.jl")
include("row_as_names.jl")
include("reinfer_schema.jl")
include("drop_missing.jl")
include("returning_original_types.jl")

# CleanTable.jl exports
export CleanTable
export size
export rename!
export rename

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

# reinfer_schema.jl exports
export reinfer_schema!
export reinfer_schema

# drop_missing.jl exports
export drop_missing!
export drop_missing

# returning_original_types.jl exports
export materializer
export compact_table_ROT
export compact_columns_ROT
export compact_rows_ROT
export delete_const_columns_ROT
export polish_names_ROT
export reinfer_schema_ROT
export row_as_names_ROT
export rename_ROT

precompile(CleanTable, (CleanTable,))
precompile(CleanTable, (Vector{Symbol}, Vector{AbstractVector}))
precompile(polish_names!, (CleanTable,))
precompile(generate_polished_names, (Vector{String},))
precompile(compact_table!, (CleanTable,))
precompile(compact_columns!, (CleanTable,))
precompile(compact_rows!, (CleanTable,))
precompile(delete_const_columns!, (CleanTable,))
precompile(row_as_names!, (CleanTable, Int64))
precompile(reinfer_schema!, (CleanTable,))

end
