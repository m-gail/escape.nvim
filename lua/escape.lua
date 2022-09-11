local api = vim.api
local M = {}

function M.escape()
    local start_pos = vim.fn.getpos('v')
    local end_pos = vim.fn.getpos('.')

    local start_row = start_pos[2]
    local start_col = start_pos[3]

    local end_row = end_pos[2]
    local end_col = end_pos[3]

    if start_row == end_row and end_col < start_col then
      end_col, start_col = start_col, end_col
    elseif end_row < start_row then
      start_row, end_row, start_col, end_col = end_row, start_row, end_col, start_col
    end

    local lines = api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
    local escaped, _ = string.format("%q", table.concat(lines, '\n')):gsub("\\\n", "\\n"):gsub("'", "\\'"):sub(2, -2)
    api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, { escaped })
end

return M
