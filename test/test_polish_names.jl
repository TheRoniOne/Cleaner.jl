using Test
using Cleaner: CleanTable, names, polish_names!, polish_names, generate_polished_names
using DataFrames: DataFrame

@testset "name polishing is working" begin
    testDF = DataFrame("  _aName with_loTsOfProblems" => [1,2,3], 
    "  _aName with_loTsOfProblems1" => [4,5,6], 
    "  _aName with_loTsOfProblems2" => [7,8,9])
    testCT = CleanTable(testDF)

    @test names(polish_names!(testCT, style=:snake_case)) == Vector{Symbol}(
        [:a_name_with_lo_ts_of_problems, :a_name_with_lo_ts_of_problems1, :a_name_with_lo_ts_of_problems2])
    
    @test names(polish_names!(testCT, style=:camelCase)) == Vector{Symbol}(
        [:aNameWithLoTsOfProblems, :aNameWithLoTsOfProblems1, :aNameWithLoTsOfProblems2])

    @test polish_names(testDF) isa CleanTable

    @test generate_polished_names(["  _aName with_loTsOfProblems", "  _aName with_loTsOfProblems", 
        "  _aName with_loTsOfProblems_1"], style=:snake_case) == Vector{Symbol}(
        [:a_name_with_lo_ts_of_problems, :a_name_with_lo_ts_of_problems_1, :a_name_with_lo_ts_of_problems_1_1])

    @test generate_polished_names(["  _aName with_loTsOfProblems", "  _aName with_loTsOfProblems", 
        "  _aName with_loTsOfProblems_1"], style=:camelCase) == Vector{Symbol}([
            :aNameWithLoTsOfProblems, :aNameWithLoTsOfProblems_1, :aNameWithLoTsOfProblems1])

    let err = nothing
        try
            generate_polished_names(["something"], style=:any)
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "Invalid style selected"
    end 

end
