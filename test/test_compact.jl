using Test
using Cleaner: CleanTable, compact_cols, compact_rows, compact_table

@testset "Compact functions working fine" begin
    testRM1 = CleanTable([:A, :B, :C], [[missing, missing, missing], [1, missing, 3], ["x", "", "z"]])
    testRM2 = CleanTable([:A, :B, :C], [["", missing, ""], [1, missing, 3], ["x", missing, "z"]])

    @test compact_cols(testRM1)
    @test compact_rows(testRM2)
    @test compact_table(testRM1)

    @test compact_cols(testRM2, empty_values=[""])
    @test compact_rows(testRM1, empty_values=[""])
    @test compact_table(testRM2, empty_values=[""])
end
