module Cleaner

include("CleanTable.jl")
include("polish_names.jl")
include("compact.jl")
include("delete_const.jl")

# CleanTable.jl exports
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

end
