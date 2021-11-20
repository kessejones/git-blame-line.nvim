local M = { }

local paddingLeft = 5

function M.padLeft(text, length)
    return string.rep(' ', length) .. text
end

function M.createExtMarkOpts(text)
    text = M.padLeft(text, paddingLeft)
    local opts = {
        virt_text = {{ text, "SpecialComment" }},
        virt_text_pos = "eol",
    }

    return opts
end

function M.showVirtualText(params)
    vim.api.nvim_buf_set_extmark(0, M.__nsId, params.line[1] -1, 0, params.opts) 
    M.isVisible = true 
end

function M.clear()
    vim.api.nvim_buf_clear_namespace(0, M.__nsId, 0, -1)
    M.isVisible = false
end

function M.setup()
    M.isVisible = false
    M.__nsId = vim.api.nvim_create_namespace('GitBlameLine')
end

return M
