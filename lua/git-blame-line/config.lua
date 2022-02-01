local config = {
    git = {
        default_message = 'Not committed yet',
        blame_format = '%an - %ar - %s'
    },
    view = {
        left_padding_size = 5,
        enable_cursor_hold = false
    }
}

function config.init(opts)
    opts = opts or {}

    for group_name, _ in pairs(config) do
        if opts[group_name] then
            for key, _ in pairs(config[group_name]) do
                if opts[group_name][key] then
                    config[group_name][key] = opts[group_name][key]
                end
            end
        end
    end
end

return config
