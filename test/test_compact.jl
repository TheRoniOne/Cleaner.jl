using Test
using Cleaner: CleanTable, compact_columns, compact_rows, compact_table, size, names

@testset "Compact functions working fine" begin
    testRM1 = CleanTable([:A, :B, :C], [[missing, missing, missing], [1, missing, 3], ["x", "", "z"]])
    testRM2 = CleanTable([:A, :B, :C], [["", missing, ""], [1, missing, 3], ["x", missing, "z"]])

    @test compact_columns(testRM1) |> size == (3, 2)
    @test compact_rows(testRM2) |> size == (2, 3)
    @test compact_table(testRM1) |> size == (3, 2)

    @test compact_columns(testRM2, empty_values=[""]) |> size == (3, 2)
    @test compact_rows(testRM1, empty_values=[""]) |> size == (2, 3)
    @test compact_table(testRM2, empty_values=[""]) |> size == (2, 2)

    @test names(compact_columns(testRM1)) == [:B, :C]
end
