using Test
using Cleaner: CleanTable, compact_columns, compact_rows, compact_rows!, compact_table,
    cols, size, names

@testset "Compact functions working fine" begin
    testRM1 = CleanTable(
        [:A, :B, :C], [[missing, missing, missing], [1, missing, 3], ["x", "", "z"]]
    )
    testRM2 = CleanTable(
        [:A, :B, :C], [["", missing, ""], [1, missing, 3], ["x", missing, "z"]]
    )

    @test size(compact_columns(testRM1)) == (3, 2)
    @test size(compact_rows(testRM2)) == (2, 3)
    @test size(compact_table(testRM1)) == (3, 2)

    @test size(compact_columns(testRM2; empty_values=[""])) == (3, 2)
    @test size(compact_rows(testRM1; empty_values=[""])) == (2, 3)
    @test size(compact_table(testRM2; empty_values=[""])) == (2, 2)

    @test names(compact_columns(testRM1)) == [:B, :C]

    if Threads.nthreads() > 1
        testRM1 = CleanTable([:A, :B], [collect(1:1_000_000), repeat([missing], 1_000_000)])
        testRM2 = CleanTable([:A, :B],
        [append!(Union{Missing, Int64}[missing], collect(1:1_000_000)),
        append!(Union{Missing, Int64}[missing], collect(1:1_000_000))])

        @test size(compact_columns(testRM1)) == (1_000_000, 1)
        @test size(compact_rows!(testRM2; empty_values=[1, 3, 10])) == (999_997, 2)
        @test !in(10, cols(testRM2)[1]) && !in(10, cols(testRM2)[2])
    end
end
