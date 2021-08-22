using Test
using Cleaner: CleanTable, reinfer_schema

@testset "reinfer_schema is working as expected" begin
    testCT = CleanTable([:A, :B, :C], [[1, 2, 3], Any[4, missing, "z"], Any["5", "6", "9"]])
    testCT2 = CleanTable([:A, :B, :C], [[1, 2, 3, 4], Any[5, missing, "z", 2.0], Any["6", "7", "8", "9"]])
    
    @test reinfer_schema(testCT)
    @test reinfer_schema(testCT2)
end
