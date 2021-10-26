using Cleaner
using Documenter

DocMeta.setdocmeta!(Cleaner, :DocTestSetup, :(using Cleaner); recursive=true)

makedocs(;
    modules=[Cleaner],
    authors="Ronald Gamez",
    repo="https://github.com/TheRoniOne/Cleaner.jl/blob/{commit}{path}#{line}",
    sitename="Cleaner.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://TheRoniOne.github.io/Cleaner.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Guide" => Any[
            "First steps" => "man/first_steps.md"
        ],
        "API" => Any[
            "Types" => "lib/types.md",
            "Functions" => "lib/functions.md"
        ]
    ],
    strict = true
)

deploydocs(;
    repo="github.com/TheRoniOne/Cleaner.jl",
)
