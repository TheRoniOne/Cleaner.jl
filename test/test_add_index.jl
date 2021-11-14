using Test
using Cleaner: CleanTable, add_index

@testset "add_index is working as expected" begin
    testCT = CleanTable([:A], [[4, 5, 6]])

    @test add_index(testCT).row_index == [1, 2, 3]
end
