local converters = require("escape.converters")
local api = vim.api

local M = {}

local VISUAL = "v"
local VISUAL_LINE = "V"
local VISUAL_BLOCK = "\22"

function M.apply_converter(convert)
    -- getpos is 1-indexed
    local start_position = vim.fn.getpos('v')
    local end_position = vim.fn.getpos('.')

    local _, start_row, start_col, _ = table.unpack(start_position)
    local _, end_row, end_col, _ = table.unpack(end_position)

    if start_row == end_row and end_col < start_col then
      end_col, start_col = start_col, end_col
    elseif end_row < start_row then
      start_row, end_row, start_col, end_col = end_row, start_row, end_col, start_col
    end

    local mode = vim.fn.mode()
    -- nvim_buf_get_lines is 0-indexed
    local lines = api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

    if mode == VISUAL_LINE then
        lines = vim.tbl_map(convert, lines)
    elseif mode == VISUAL then
        local new_lines = {}
        for index, line in ipairs(lines) do
            if index == 1 then
                table.insert(new_lines, line:sub(1, start_col - 1) .. convert(line:sub(start_col, -1)))
            elseif index == vim.tbl_count(lines) then
                table.insert(new_lines, convert(line:sub(0, end_col)) .. line:sub(end_col + 1, -1))
            else
                table.insert(new_lines, convert(line))
            end
        end
        lines = new_lines
    elseif mode == VISUAL_BLOCK then
        local left_col = math.min(start_col, end_col)
        local right_col = math.max(start_col, end_col)
        lines = vim.tbl_map(function (line)
            return line:sub(1, left_col - 1) .. convert(line:sub(left_col, right_col)) .. line:sub(right_col + 1, -1)
        end, lines)
    end

    -- nvim_buf_set_lines is 0-indexed
    api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
end

function M.escape()
    M.apply_converter(converters.escape)
end

function M.encode_uri_component()
    M.apply_converter(converters.encode_uri_component)
end

return M
