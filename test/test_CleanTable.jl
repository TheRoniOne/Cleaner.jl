using Test
using Cleaner: CleanTable
import Tables

@testset "CleanTable works as expected" begin
    testCT = CleanTable([:A, :B, :C], [[1, 2, 3], [4, 5, 6], String["7", "8", "9"]])
    nt = (A=[1,2,3], B=["x", "y", "z"])

    CleanTable(nt)
end
