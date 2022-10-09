local M = {}

function M.escape(text)
    return string.format("%q", text):gsub("\\\n", "\\n"):gsub("'", "\\'"):sub(2, -2)
end

function M.encode_uri_component(text)
    text = text:gsub("([^A-Za-z0-9%-_.!~*'()])", function (c)
        return string.format("%%%02X", string.byte(c))
    end)
    return text
end

return M
