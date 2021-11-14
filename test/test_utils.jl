using Test
using Cleaner: CleanTable, get_all_repeated

@testset "get_all_repeated is working as expected" begin
    testCT = CleanTable([:A, :B], [["y", "x", "y"], ["x", "x", "x"]])

    let result = nothing
        result = get_all_repeated(testCT, [:A])
        @test result.row_index == [1, 3]
        @test result.A == ["y", "y"]
    end

    let result = nothing
        result = get_all_repeated(testCT, [:A, :B])
        @test result.row_index == [1, 3]
        @test result.A == ["y", "y"]
        @test result.B == ["x", "x"]
    end
end
