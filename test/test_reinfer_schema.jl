using Test
using Tables: schema, Schema
using Cleaner: CleanTable, reinfer_schema

@testset "reinfer_schema is working as expected" begin
    testCT = CleanTable([:A, :B, :C], [[1, 2, 3], Any[4, missing, "z"], Any["5", "6", "9"]])
    testCT2 = CleanTable([:A, :B, :C], [[1, 2, 3, 4], Any[5, missing, "z", 2.0], Any["6", "7", "8", "9"]])
    
    @test schema(reinfer_schema(testCT)) == Schema([:A, :B, :C], [Int, Union{Missing, String, Int}, String])
    @test schema(reinfer_schema(testCT2)) == Schema([:A, :B, :C], [Int, Union{Missing, Real, String}, String])
    @test schema(reinfer_schema(testCT2, max_types=2)) == Schema([:A, :B, :C], [Int, Any, String])
end
