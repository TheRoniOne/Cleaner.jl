using SafeTestsets

@safetestset "test_CleanTable.jl" begin include("test_CleanTable.jl") end
@safetestset "test_polish_names.jl" begin include("test_polish_names.jl") end
@safetestset "test_compact.jl" begin include("test_compact.jl") end
@safetestset "test_delete_const.jl" begin include("test_delete_const.jl") end
@safetestset "test_row_as_names.jl" begin include("test_row_as_names.jl") end
@safetestset "test_reinfer_schema.jl" begin include("test_reinfer_schema.jl") end
