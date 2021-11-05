using Test
using Cleaner: CleanTable, drop_missing, size, cols

@testset "Drop_missing functions working as expected" begin
    testCT = CleanTable([:A, :B, :C], [[1, 2, 3], [4, missing, 5], ["x", "y", ""]])

    @test size(drop_missing(testCT)) == (2, 3)
    @test size(drop_missing(testCT; missing_values=[""])) == (1, 3)

    if Threads.nthreads() > 1
        testRM = CleanTable([:A, :B],
        [append!(Union{Missing, Int64}[missing], collect(1:1_000_000)),
        append!(Union{Missing, Int64}[missing], collect(1:1_000_000))])

        testRM1 = drop_missing(testRM; missing_values=[1, 3, 10])

        @test size(testRM1) == (999_997, 2)
        @test !in(10, cols(testRM1)[1]) && !in(10, cols(testRM1)[2])
    end
end
