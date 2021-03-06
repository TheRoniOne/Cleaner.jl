using Test
using Cleaner: CleanTable, names, rename
import Tables

@testset "CleanTable satisfies Tables.jl interface" begin
    testCT = CleanTable([:A, :B, :C], [[1, 2, 3], [4, 5, 6], String["7", "8", "9"]])

    @test Tables.istable(typeof(testCT))
    @test Tables.columnaccess(typeof(testCT))
    @test Tables.columns(testCT) === testCT
    @test testCT.A == [1, 2, 3]
    @test Tables.getcolumn(testCT, :A) == [1, 2, 3]
    @test Tables.getcolumn(testCT, 1) == [1, 2, 3]
    @test Tables.columnnames(testCT) == [:A, :B, :C]

    nt = (A=[1,2,3], B=["x", "y", "z"])
    ctNT = Tables.materializer(testCT)(nt)
    @test nt |> CleanTable isa CleanTable
    @test ctNT isa CleanTable
    @test Tables.columntable(ctNT) == (A = [1, 2, 3], B = ["x", "y", "z"])
    @test Tables.rowtable(ctNT) == [(A = 1, B = "x"), (A = 2, B = "y"), (A = 3, B = "z")]

    ctNT.A[1] = 5
    @test ctNT.A != nt.A
    ctNT = CleanTable(nt, copycols=false)
    ctNT.A[1] = 5
    @test ctNT.A === nt.A
end

@testset "CleanTable works as expected" begin
    testCT = CleanTable([:A, :B, :C], [[1, 2, 3], [4, 5, 6], String["7", "8", "9"]])

    @test CleanTable(testCT) isa CleanTable

    testCT.A = [7, 8, 9]
    @test testCT[1] == [7, 8, 9]

    testCT2 = rename(testCT, [:x, :y, :z])
    @test names(testCT2) == [:x, :y, :z]

    let err = nothing
        try
            rename(testCT, [:a, :b])
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "Inconsistent length between names given and amount of columns"
    end

    let err = nothing
        try
            CleanTable([:A, :B, :C], [[1, 2, 3], [4, 5, 6]])
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "Inconsistent length between names given and
        amount of columns"
    end

    let err = nothing
        try
            CleanTable([:A, :B], [[1, 2, 3], [4, 5]])
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "All columns must be of the same length"
    end

    let err = nothing
        try
            testCT.names = [:x, :y, :z]
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "Changing property 'names' directly is unsupported, please use the `rename!` function"
    end

    let err = nothing
        try
            tmp = CleanTable([:A, :B], [[1, 2, 3], [4, 5, 6]])
            tmp.cols = [[5,6,7], ["x", "y", "z"]]
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "Property 'cols' cannot be changed"
    end

    let err = nothing
        try
            tmp = CleanTable([:A, :B], [[1, 2, 3], [4, 5, 6]])
            tmp.c = [7, 8, 9]
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "Property 'c' does not exist"
    end

    @test CleanTable([:A, :B], [collect(1:1_000_000), collect(1:1_000_000)])[1] |> length == 1_000_000

    let err = nothing
        try
            tmp = CleanTable([:A, :B], [[1, 2, 3], [4, 5, 6]])
            tmp.A = [1]
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "Length of the AbstractVector being assigned to column 'A' must be consistent with the length of the rest of columns"
    end

    let err = nothing
        try
           tmp = CleanTable([:A, :B], [[1, 2, 3], [4, 5, 6]])
           tmp.A = 1
        catch err
        end
        @test err isa Exception
        @test sprint(showerror, err) == "Value being assigned must be an AbstractVector"
    end
end
