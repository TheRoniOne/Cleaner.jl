using Base: String
import Tables: rows, columnnames

function polish_names(table; style="snake_case")
    row = Tables.rows(table)[1]
    names = Tables.columnnames(row)
    
    new_names = generate_polished_names(names, style)
end

function generate_polished_names(names; style="snake_case")
    new_names = Vector{Symbol}()

    if style == "snake_case"
        for name in names
            new_name = Symbol(join(split(_replace_uppers(String(name)), r"[\s\-.]", keepempty=false), "_"))
            push!(new_names, new_name)
        end
    elseif style == "camelCase"
        for name in names
            new_name = Symbol(lowercasefirst(join(uppercasefirst.(split(String(name), r"[\s\-._]", keepempty=false)), "")))
            push!(new_names, new_name)
        end
    end

    return new_names
end

function _replace_uppers(word)
    fixed_word = ""

    for letter in word
        if isuppercase(letter)
            fixed_word = fixed_word * "_" * lowercase(letter)
        else
            fixed_word = fixed_word * letter
        end
    end

    return fixed_word
end
