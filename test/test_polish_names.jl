using Test
using Cleaner: polish_names!, generate_polished_names
using DataFrames: DataFrame, rename!
import Tables: columnnames

@testset "name polishing is working" begin
    testDF = DataFrame("  _aName with_loTsOfProblems" => [1,2,3], 
    "  _aName with_loTsOfProblems1" => [4,5,6], 
    "  _aName with_loTsOfProblems2" => [7,8,9])

    @test Tables.columnnames(polish_names!(testDF, style="snake_case")) == Vector{Symbol}(
        [:a_name_with_lo_ts_of_problems, :a_name_with_lo_ts_of_problems1, :a_name_with_lo_ts_of_problems2])
    
    @test Tables.columnnames(polish_names!(testDF, style="camelCase")) == Vector{Symbol}(
        [:aNameWithLoTsOfProblems, :aNameWithLoTsOfProblems1, :aNameWithLoTsOfProblems2])

    @test generate_polished_names(["  _aName with_loTsOfProblems", "  _aName with_loTsOfProblems", 
        "  _aName with_loTsOfProblems_1"], style="snake_case") == Vector{Symbol}(
        [:a_name_with_lo_ts_of_problems, :a_name_with_lo_ts_of_problems_1, :a_name_with_lo_ts_of_problems_1_1])

    @test generate_polished_names(["  _aName with_loTsOfProblems", "  _aName with_loTsOfProblems", 
        "  _aName with_loTsOfProblems_1"], style="camelCase") == Vector{Symbol}([
            :aNameWithLoTsOfProblems, :aNameWithLoTsOfProblems_1, :aNameWithLoTsOfProblems1])

end
