local git = require'git-blame-line.git'
local view = require'git-blame-line.view'

local M = { }

function M:commands()
    vim.cmd[[autocmd CursorHold * lua require'git-blame-line'.blame()]]
    vim.cmd[[autocmd CursorMoved * lua require'git-blame-line'.clear()]]
    vim.cmd[[autocmd CursorMovedI * lua require'git-blame-line'.clear()]]
    vim.api.nvim_exec([[command GitBlameLine :lua require'git-blame-line'.blame()]], false)
    vim.api.nvim_exec([[command GitBlameLineToggle :lua require'git-blame-line'.toggle()]], false)
end

function M.blame()
    local ft = vim.fn.expand("%:h:t")
    if ft == '' or ft == 'bin' then
        return
    end
    
    M.clear()

    local line = vim.api.nvim_win_get_cursor(0)
    local currentFile = vim.fn.expand('%')
    local blameText = git.blameText(currentFile, line)
    local opts = view.createExtMarkOpts(blameText)
    local params = {
        line = line,
        opts = opts,
    }
    view.showVirtualText(params)
end

function M.clear()
    view.clear()
end

function M.toggle()
    if view.isVisible then
        M.clear()
    else
        M.blame()
    end
end

function M.setup()
    M:commands()
    view.setup()
end

return M
