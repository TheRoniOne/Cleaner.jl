using Base: String
using Tables: rows, columnnames

function polish_names!(table, f_rename!; style="snake_case")
    row = rows(table)[1]
    names = columnnames(row)
    
    new_names = generate_polished_names(names; style)
    return f_rename!(table, new_names)
end

function generate_polished_names(names; style="snake_case")
    new_names = Vector{String}()

    if style == "snake_case"
        for name in names
            new_name = _sanitize_snake_case(join(split(_replace_uppers(String(name)), r"[\s\-.]", keepempty=false), "_"))
            push!(new_names, new_name)
        end
    elseif style == "camelCase"
        for name in names
            new_name = lowercasefirst(join(uppercasefirst.(split(String(name), r"[\s\-._]", keepempty=false)), ""))
            push!(new_names, new_name)
        end
    end

    return _sanitize_dupes(new_names)
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

function _sanitize_snake_case(dirty_snake)
    new_name = ""
    under_score_behind = false

    for letter in strip(dirty_snake, '_')
        if letter != '_'
            new_name = new_name * letter
            under_score_behind = false
        elseif !under_score_behind
            new_name = new_name * letter
            under_score_behind = true
        end
    end

    return new_name
end

function _sanitize_dupes(names)
    new_names = Vector{Symbol}()
    dupes = Dict{String, Int64}()

    for name in names
        if !(Symbol(name) in new_names)
            push!(new_names, Symbol(name))
        else
            dupes["$name"] = get(dupes, name, 0) + 1
            push!(new_names, Symbol(name * "_" * string(get(dupes, name, 0))))
        end
    end

    return new_names
end
