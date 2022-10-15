local util = require('escape.util')
local api = vim.api

local M = {}

function M.operatorfunc(motion)
    local start_position = api.nvim_buf_get_mark(0, '[')
    local end_position = api.nvim_buf_get_mark(0, ']')

    -- nvim_buf_get_mark is {1, 0}-indexed and has to be made {1, 1}-indexed
    start_position[2] = start_position[2] + 1
    end_position[2] = end_position[2] + 1

    util.apply_converter_to_range(M.convert, start_position, end_position, motion)
end

return M
