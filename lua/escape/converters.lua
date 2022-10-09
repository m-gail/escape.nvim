local M = {}

function M.escape_text(text)
    return string.format("%q", text):gsub("\\\n", "\\n"):gsub("'", "\\'"):sub(2, -2)
end

return M
