export def main [] { return {
    separator: "#e97e8a"
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: "#d95362" attr: "b" }
    empty: "#cebabf"
    bool: {|| if $in { "#ff987c" } else { "light_gray" } }
    int: "#e97e8a"
    filesize: {|e|
        if $e == 0b {
            "#e97e8a"
        } else if $e < 1mb {
            "#ff7550"
        } else {{ fg: "#cebabf" }}
    }
    duration: "#e97e8a"
    date: {|| (date now) - $in |
        if $in < 1hr {
            { fg: "#8ea84d" attr: "b" }
        } else if $in < 6hr {
            "#8ea84d"
        } else if $in < 1day {
            "#65aba3"
        } else if $in < 3day {
            "#d95362"
        } else if $in < 1wk {
            { fg: "#d95362" attr: "b" }
        } else if $in < 6wk {
            "#ff7550"
        } else if $in < 52wk {
            "#cebabf"
        } else { "dark_gray" }
    }
    range: "#e97e8a"
    float: "#e97e8a"
    string: "#e97e8a"
    nothing: "#e97e8a"
    binary: "#e97e8a"
    cellpath: "#e97e8a"
    row_index: { fg: "#d95362" attr: "b" }
    record: "#e97e8a"
    list: "#e97e8a"
    block: "#e97e8a"
    hints: "dark_gray"
    search_result: { fg: "#ff987c" bg: "#442022" }

    shape_and: { fg: "#ce8b9f" attr: "b" }
    shape_binary: { fg: "#ce8b9f" attr: "b" }
    shape_block: { fg: "#cebabf" attr: "b" }
    shape_bool: "#ff987c"
    shape_custom: "#d95362"
    shape_datetime: { fg: "#ff7550" attr: "b" }
    shape_directory: "#ff7550"
    shape_external: "#ff7550"
    shape_externalarg: { fg: "#d95362" attr: "b" }
    shape_filepath: "#ff7550"
    shape_flag: { fg: "#cebabf" attr: "b" }
    shape_float: { fg: "#ce8b9f" attr: "b" }
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: "b" }
    shape_globpattern: { fg: "#ff7550" attr: "b" }
    shape_int: { fg: "#ce8b9f" attr: "b" }
    shape_internalcall: { fg: "#ff7550" attr: "b" }
    shape_list: { fg: "#ff7550" attr: "b" }
    shape_literal: "#cebabf"
    shape_match_pattern: "#d95362"
    shape_matching_brackets: { attr: "u" }
    shape_nothing: "#ff987c"
    shape_operator: "#65aba3"
    shape_or: { fg: "#ce8b9f" attr: "b" }
    shape_pipe: { fg: "#ce8b9f" attr: "b" }
    shape_range: { fg: "#65aba3" attr: "b" }
    shape_record: { fg: "#ff7550" attr: "b" }
    shape_redirection: { fg: "#ce8b9f" attr: "b" }
    shape_signature: { fg: "#d95362" attr: "b" }
    shape_string: "#d95362"
    shape_string_interpolation: { fg: "#ff7550" attr: "b" }
    shape_table: { fg: "#cebabf" attr: "b" }
    shape_variable: "#ce8b9f"

    background: "#190f0f"
    foreground: "#e97e8a"
    cursor: "#e97e8a"
}}