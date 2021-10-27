# A name-changing help

## Column names polishing

Having repated column names, names with spaces in them, names where spaces are padding the beginning or the
end, names with inconsistent formating, etc can certainly become a trouble when trying to reference a certain
column during your workflow.

To tackle this problems directly, we have the functions `polish_names` and `polish_names!` used as follows:

```jldoctest name_polish
julia> using Cleaner

julia> ct = CleanTable([Symbol(" Horrible name 1"), Symbol("another_bad Name  ")], [[1], [2]])
┌──────────────────┬────────────────────┐
│  Horrible name 1 │ another_bad Name   │
│            Int64 │              Int64 │
├──────────────────┼────────────────────┤
│                1 │                  2 │
└──────────────────┴────────────────────┘


julia> polish_names(ct)
┌─────────────────┬──────────────────┐
│ horrible_name_1 │ another_bad_name │
│           Int64 │            Int64 │
├─────────────────┼──────────────────┤
│               1 │                2 │
└─────────────────┴──────────────────┘


julia> polish_names(ct; style=:camelCase)
┌───────────────┬────────────────┐
│ horribleName1 │ anotherBadName │
│         Int64 │          Int64 │
├───────────────┼────────────────┤
│             1 │              2 │
└───────────────┴────────────────┘


```

!!! note

    Currently the only available styles are `:snake_case` and `:camelCase`. 
    The default style is `:snake_case`.

Internally `polish_names` and `polish_names!` both call the `generate_polished_names` function, so if you just need
to generate better names for your table, you could call it as follows and manually rename your table.

```jldoctest name_polish
julia> generate_polished_names(["  _aName with_lotsOfProblems", "  _aName with_lotsOfProblems"])
2-element Vector{Symbol}:
 :a_name_with_lots_of_problems
 :a_name_with_lots_of_problems_1

julia> generate_polished_names(["  _aName with_lotsOfProblems", "  _aName with_lotsOfProblems"]; style=:camelCase)
2-element Vector{Symbol}:
 :aNameWithLotsOfProblems
 :aNameWithLotsOfProblems_1

```

If all you want is to change the column names to be your desired ones, you can always use the `rename` and 
`rename!` functions.

```jldoctest name_polish
julia> rename(ct, [:A, :B])
┌───────┬───────┐
│     A │     B │
│ Int64 │ Int64 │
├───────┼───────┤
│     1 │     2 │
└───────┴───────┘


```

## Making a row be the column names

When working with messy data you might end up having the row names being the second or third row of the table you have
loaded. For this cases you can use the `row_as_names` and `row_as_names!` functions.

```jldoctest promoting_rows; setup = :(using Cleaner)
julia> ct = CleanTable([Symbol(" "), Symbol(" ")], [[" ", "A", 1], [" ", "B", 2]])
┌─────┬─────┐
│     │     │
│ Any │ Any │
├─────┼─────┤
│     │     │
│   A │   A │
│   1 │   1 │
└─────┴─────┘


julia> row_as_names(ct, 2)
┌─────┬─────┐
│   A │   B │
│ Any │ Any │
├─────┼─────┤
│   1 │   2 │
└─────┴─────┘


julia> row_as_names(ct, 2; remove=false)
┌─────┬─────┐
│   A │   B │
│ Any │ Any │
├─────┼─────┤
│     │     │
│   A │   B │
│   1 │   2 │
└─────┴─────┘


```
