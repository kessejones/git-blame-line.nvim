local config = {}

local default_config = {
    git = {
        default_message = "Not committed yet",
        blame_format = "%an - %ar - %s",
    },
    view = {
        left_padding_size = 5,
        enable_cursor_hold = false,
    },
}

function config.init(opts)
    opts = vim.tbl_deep_extend("force", default_config, opts or {})

    config.git = opts.git
    config.view = opts.view
end

return config
