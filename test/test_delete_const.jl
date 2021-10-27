using Test
using Cleaner: CleanTable, delete_const_columns, size, names

@testset "Delete constant columns works as expected" begin
    testCT = CleanTable([:A, :B, :C], [[1, 1, 1], [4, 5, 6], String["2", "2", "2"]])

    @test size(delete_const_columns(testCT)) == (3, 1)
    @test names(delete_const_columns(testCT)) == [:B]
    @test delete_const_columns(testCT) isa CleanTable

    if Threads.nthreads() > 1
        testCT2 = CleanTable([:A, :B, :C], [repeat([1], 1_000_000), collect(1:1_000_000), repeat([2], 1_000_000)])
        @test size(delete_const_columns(testCT2)) == (1_000_000, 1)
        @test names(delete_const_columns(testCT2)) == [:B]
    end
end
