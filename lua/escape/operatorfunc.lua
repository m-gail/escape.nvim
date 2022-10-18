local util = require('escape.util')
local api = vim.api

local M = {}

---Operatorfunc, which applies the convert function of its table to the selected visual area or text object
---@param motion string
function M.operatorfunc(motion)
    local start_position = api.nvim_buf_get_mark(0, '[')
    local end_position = api.nvim_buf_get_mark(0, ']')

    -- nvim_buf_get_mark is {1, 0}-indexed and has to be made {1, 1}-indexed
    start_position[2] = start_position[2] + 1
    end_position[2] = end_position[2] + 1

    util.apply_converter_to_range(M.convert, start_position, end_position, motion)
end

return M
