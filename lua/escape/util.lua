local api = vim.api
local M = {}

local VISUAL = "char"
local VISUAL_LINE = "line"
local VISUAL_BLOCK = "block"

local unpack_table = table.unpack or unpack;

---Applies a converter to the text in a range
---@param convert fun(line:string):string
---@param start_position table
---@param end_position table
---@param mode "char" | "line" | "block"
function M.apply_converter_to_range(convert, start_position, end_position, mode)
    local start_row, start_col = unpack_table(start_position)
    local end_row, end_col = unpack_table(end_position)

    if start_row == end_row and end_col < start_col then
        end_col, start_col = start_col, end_col
    elseif end_row < start_row then
        start_row, end_row, start_col, end_col = end_row, start_row, end_col, start_col
    end

    -- nvim_buf_get_lines is 0-indexed
    local lines = api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

    if mode == VISUAL_LINE then
        lines = vim.tbl_map(convert, lines)
    elseif mode == VISUAL then
        local new_lines = {}
        if vim.tbl_count(lines) > 1 then
            for index, line in ipairs(lines) do
                if index == 1 then
                    table.insert(new_lines, line:sub(1, start_col - 1) .. convert(line:sub(start_col, -1)))
                elseif index == vim.tbl_count(lines) then
                    table.insert(new_lines, convert(line:sub(0, end_col)) .. line:sub(end_col + 1, -1))
                else
                    table.insert(new_lines, convert(line))
                end
            end
        else
            table.insert(
                new_lines,
                lines[1]:sub(1, start_col - 1) ..
                convert(lines[1]:sub(start_col, end_col)) .. lines[1]:sub(end_col + 1, -1)
            )
        end
        lines = new_lines
    elseif mode == VISUAL_BLOCK then
        local left_col = math.min(start_col, end_col)
        local right_col = math.max(start_col, end_col)
        lines = vim.tbl_map(function(line)
            return line:sub(1, left_col - 1) .. convert(line:sub(left_col, right_col)) .. line:sub(right_col + 1, -1)
        end, lines)
    end

    api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
end

return M
