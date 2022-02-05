local config = require("git-blame-line.config")

local view = {
    is_visible = false,
    __ns_id = nil,
}

function view.pad_left(text)
    return string.rep(" ", config.view.left_padding_size) .. text
end

function view.create_ext_mark_opts(text)
    text = view.pad_left(text)
    local opts = {
        virt_text = { { text, "Comment" } },
        virt_text_pos = "eol",
        hl_mode = "combine",
    }

    return opts
end

function view.show_virtual_text(params)
    vim.api.nvim_buf_set_extmark(0, view.__ns_id, params.line[1] - 1, 0, params.opts)
    view.is_visible = true
end

function view.clear()
    vim.api.nvim_buf_clear_namespace(0, view.__ns_id, 0, -1)
    view.is_visible = false
end

function view.init()
    view.is_visible = false
    view.__ns_id = vim.api.nvim_create_namespace("GitBlameLine")
end

return view
