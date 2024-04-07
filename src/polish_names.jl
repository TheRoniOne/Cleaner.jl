using Base: String
using Unicode: normalize

struct Style{T} end

Style(s::Symbol) = Style{s}()

const SPECIAL_CHARS = r"[\s\-\.\_\/\:\\\*\?\"\'\>\<\|\!\,\$\@\^\[\]\{\}]"

"""
    polish_names!(table::CleanTable; style::Symbol=:snake_case)

Return a `CleanTable` where column names have been replaced to be unique and formated using
the `style` selected.

# Styles
- snake_case
- camelCase
"""
function polish_names!(table::CleanTable; style::Symbol=:snake_case)
    rename!(table, generate_polished_names(names(table); style=style))

    return table
end

"""
    polish_names(table; style=:snake_case)

Create and return a `CleanTable` with copied columns having column names replaced to be unique and formated
using the `style` selected.

# Styles
- snake_case
- camelCase
"""
function polish_names(table; style::Symbol=:snake_case)
    return polish_names!(CleanTable(table); style=style)
end

"""
    generate_polished_names(names; style::Symbol=:snake_case)

Return a vector of symbols containing new names that are unique and formated using the `style` selected.
"""
function generate_polished_names(names; style::Symbol=:snake_case)
    names = _preprocess_name.(names)

    return generate_polished_names(names, Style(style))
end

function generate_polished_names(names, ::Style{:snake_case})
    new_names = Vector{String}()

    for name in names
        new_name = _sanitize_snake_case(
            join(split(_replace_uppers(name), SPECIAL_CHARS; keepempty=false), "_")
        )
        push!(new_names, new_name)
    end

    return _sanitize_dupes(new_names)
end

function generate_polished_names(names, ::Style{:camelCase})
    new_names = Vector{String}()

    for name in names
        new_name = lowercasefirst(
            join(uppercasefirst.(split(name, SPECIAL_CHARS; keepempty=false)), "")
        )
        push!(new_names, new_name)
    end

    return _sanitize_dupes(new_names)
end

function generate_polished_names(names, ::Style)
    return error("Invalid style selected. Options are :snake_case, :camelCase")
end

function _preprocess_name(name)
    preprocessed = normalize(String(name); stripmark=true)

    matched = match(r"^[[:upper:]]+|\%|\#$", preprocessed)
    if matched !== nothing
        preprocessed = lowercase(preprocessed)
    end

    preprocessed = replace(preprocessed, "%" => "Percent", "#" => "Number")

    return preprocessed
end

function _replace_uppers(word)
    fixed_word = ""

    previous_letter = ' '
    for letter in word
        fixed_word = _construct_fixed_word(previous_letter, letter, fixed_word)

        previous_letter = letter
    end

    fixed_word = _construct_fixed_word(previous_letter, ' ', fixed_word)
    return fixed_word
end

function _construct_fixed_word(previous_letter, letter, fixed_word)
    if islowercase(previous_letter)
        if isuppercase(letter)
            return fixed_word * lowercase(previous_letter) * "_"
        else
            return fixed_word * previous_letter
        end
    else
        return fixed_word * lowercase(previous_letter)
    end
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
    dupes = Dict{String,Int64}()

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
