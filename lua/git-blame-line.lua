local git = require'git-blame-line.git'
local view = require'git-blame-line.view'
local config = require'git-blame-line.config'

local git_blame_line = {}

function git_blame_line.register_commands()
    vim.api.nvim_exec([[command GitBlameLineShow :lua require'git-blame-line'.blame()]], false)
    vim.api.nvim_exec([[command GitBlameLineClear :lua require'git-blame-line'.clear()]], false)
    vim.api.nvim_exec([[command GitBlameLineToggle :lua require'git-blame-line'.toggle()]], false)

    if config.view.enable_cursor_hold then
        vim.cmd[[autocmd CursorHold * :GitBlameLineShow]]
        vim.cmd[[autocmd CursorMoved * :GitBlameLineClear]]
        vim.cmd[[autocmd CursorMovedI * :GitBlameLineClear]]
    end
end

function git_blame_line.blame()
    local ft = vim.fn.expand("%:h:t")
    if ft == '' or ft == 'bin' then
        return
    end

    git_blame_line.clear()

    local line = vim.api.nvim_win_get_cursor(0)
    local current_file = vim.fn.expand('%')
    local blame_text = git.blame_line(current_file, line)
    local opts = view.create_ext_mark_opts(blame_text)
    local params = {
        line = line,
        opts = opts,
    }

    view.show_virtual_text(params)
end

function git_blame_line.clear()
    view.clear()
end

function git_blame_line.toggle()
    if view.is_visible then
        git_blame_line.clear()
    else
        git_blame_line.blame()
    end
end

function git_blame_line.setup(opts)
    config.init(opts)
    view.init()

    git_blame_line.register_commands()
end

return git_blame_line
