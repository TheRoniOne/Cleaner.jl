using Test
using Cleaner: CleanTable, delete_const_columns, size

@testset "Delete constant columns works as expected" begin
    testCT = CleanTable([:A, :B, :C], [[1, 1, 1], [4, 5, 6], String["7", "8", "9"]])

    @test delete_const_columns(testCT) |> size == (3, 2)
    @test delete_const_columns(testCT) isa CleanTable
end
