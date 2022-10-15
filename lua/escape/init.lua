local converters = require("escape.converters")
local operatorfunc = require("escape.operatorfunc")

local api = vim.api
local M = {}

function M.apply_converter(convert)
    operatorfunc.convert = convert
    api.nvim_set_option('operatorfunc', "v:lua.require'escape.operatorfunc'.operatorfunc")
    api.nvim_feedkeys('g@', '', '')
end

function M.escape()
    M.apply_converter(converters.escape)
end

function M.encode_uri_component()
    M.apply_converter(converters.encode_uri_component)
end

return M
