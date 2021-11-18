using Test
using Cleaner: CleanTable, get_all_repeated, level_distribution, compare_table_columns

@testset "get_all_repeated is working as expected" begin
    testNT = (; A=["y", "x", "y"], B=["x", "x", "x"])

    result = get_all_repeated(testNT, [:A])
    @test result.row_index == [1, 3]
    @test result.A == ["y", "y"]

    result = get_all_repeated(testNT, [:A, :B])
    @test result.row_index == [1, 3]
    @test result.A == ["y", "y"]
    @test result.B == ["x", "x"]

    let err = nothing
        try
            get_all_repeated(testNT, [:C])
        catch err
        end

        @test err isa Exception
        @test sprint(showerror, err) == "All column names specified must exist in the table"
    end

    if Threads.nthreads() > 1
        testCT = CleanTable(
            [:A, :B],
            [
                append!(repeat([1, 2], 2), collect(5:1_000_000)),
                append!(repeat([1, 2], 2), collect(5:1_000_000)),
            ],
        )
        result = get_all_repeated(testCT, [:A, :B])

        @test result.row_index == [2, 4, 1, 3]
        @test result.A == [2, 2, 1, 1]
        @test result.B == [2, 2, 1, 1]
    end
end

@testset "level_distribution is working as expected" begin
    testNT = (; A=["y", "x", "y"], B=["x", "x", "x"])

    result = level_distribution(testNT, [:A, :B])
    @test result.value == [Any["y", "x"], Any["x", "x"]]
    @test result.percent == [0.667, 0.333]

    result = level_distribution(testNT, [:A, :B]; round_digits=2)
    @test result.value == [Any["y", "x"], Any["x", "x"]]
    @test result.percent == [0.67, 0.33]

    let err = nothing
        try
            level_distribution(testNT, [:C])
        catch err
        end

        @test err isa Exception
        @test sprint(showerror, err) == "All column names specified must exist in the table"
    end

    if Threads.nthreads() > 1
        testCT = CleanTable(
            [:A, :B],
            [
                append!(repeat([1, 2], 200_000), repeat([3, 4], 300_000)),
                append!(repeat([1, 2], 200_000), repeat([3, 4], 300_000)),
            ],
        )
        result = level_distribution(testCT, [:A, :B])
        @test length(result.value) == 4
        @test result.percent == [0.3, 0.3, 0.2, 0.2]
    end
end

@testset "compare_table_columns is working as expected" begin
    testCT = CleanTable([:A, :B, :C], [[1, 2, 3], [4, 5, 6], String["7", "8", "9"]])

    testCT2 = CleanTable(
        [:A, :B, :D], [[missing, missing, missing], [1, missing, 3], ["x", "", "z"]]
    )

    result = compare_table_columns(testCT, testCT2)
    @test result.column_name == [:A, :B, :C, :D]
    @test result.tbl1 == [Int, Int, String, Nothing]
    @test result.tbl2 == [Missing, Union{Missing, Int}, Nothing, String]
end
