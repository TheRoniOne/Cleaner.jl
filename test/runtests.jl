using SafeTestsets

@safetestset "test_CleanTable.jl" begin include("test_CleanTable.jl") end
@safetestset "test_polish_names.jl" begin include("test_polish_names.jl") end
@safetestset "test_compact.jl" begin include("test_compact.jl") end
@safetestset "test_delete_const.jl" begin include("test_delete_const.jl") end
