using Test
using Cleaner:
    materializer,
    compact_table_ROT,
    compact_columns_ROT,
    compact_rows_ROT,
    delete_const_columns_ROT,
    polish_names_ROT,
    reinfer_schema_ROT,
    row_as_names_ROT,
    rename_ROT,
    drop_missing_ROT
using DataFrames: DataFrame

@testset "ROT functions are working as expected" begin
    testRM1 = DataFrame(;
        A=[missing, missing, missing], B=[1, missing, 3], C=["x", "", "z"]
    )

    @test compact_columns_ROT(testRM1) isa DataFrame
    @test compact_rows_ROT(testRM1) isa DataFrame
    @test compact_table_ROT(testRM1) isa DataFrame
    @test materializer(testRM1)((a=[1], b=[2])) isa DataFrame

    let testDF = DataFrame(; A=[1, 1, 1], B=[4, 5, 6], C=String["2", "2", "2"])
        @test delete_const_columns_ROT(testDF) isa DataFrame
    end

    let testDF = DataFrame(
            "  _aName with_loTsOfProblems" => [1, 2, 3],
            "  _aName with_loTsOfProblems1" => [4, 5, 6],
            "  _aName with_loTsOfProblems2" => [7, 8, 9],
        )
        @test polish_names_ROT(testDF) isa DataFrame
    end

    let testDF = DataFrame(; A=[1, 2, 3], B=Any[4, missing, "z"], C=Any["5", "6", "9"])
        @test reinfer_schema_ROT(testDF) isa DataFrame
    end

    let testDF = DataFrame(; A=[1, 2, "x", 4], B=[5, 6, "y", 7], C=["x", "y", "z", "a"])
        @test row_as_names_ROT(testDF, 3) isa DataFrame
    end

    let testDF = DataFrame(; A=[1, 2, "x", 4], B=[5, 6, "y", 7], C=["x", "y", "z", "a"])
        @test rename_ROT(testDF, [:a, :b, :c]) isa DataFrame
    end

    let testDF = DataFrame(; A=[1, 2, "x", 4], B=[5, 6, "y", 7], C=["x", "y", "z", "a"])
        @test drop_missing_ROT(testDF) isa DataFrame
    end
end
