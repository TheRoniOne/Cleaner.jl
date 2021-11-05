using SafeTestsets

if Threads.nthreads() > 1
    @show Threads.nthreads()
else
    @warn("Tests using only 1 thread, multithreaded code will not be tested.")
end

@safetestset "test_CleanTable.jl" begin include("test_CleanTable.jl") end
@safetestset "test_polish_names.jl" begin include("test_polish_names.jl") end
@safetestset "test_compact.jl" begin include("test_compact.jl") end
@safetestset "test_delete_const.jl" begin include("test_delete_const.jl") end
@safetestset "test_row_as_names.jl" begin include("test_row_as_names.jl") end
@safetestset "test_reinfer_schema.jl" begin include("test_reinfer_schema.jl") end
@safetestset "test_drop_missing.jl" begin include("test_drop_missing.jl") end
@safetestset "test_returning_original.jl" begin include("test_returning_original.jl") end
