local git = require("git-blame-line.git")
local view = require("git-blame-line.view")
local config = require("git-blame-line.config")

local create_cmd = vim.api.nvim_create_user_command
local create_autocmd = vim.api.nvim_create_autocmd

local git_blame_line = {}

local function register_commands()
    create_cmd("GitBlameLineShow", git_blame_line.blame, {})
    create_cmd("GitBlameLineClear", git_blame_line.clear, {})
    create_cmd("GitBlameLineToggle", git_blame_line.toggle, {})
end

local function register_autocmds()
    local group = vim.api.nvim_create_augroup("GiBlameLine", { clear = true })
    create_autocmd("CursorMoved", { callback = git_blame_line.clear, group = group })
    create_autocmd("CursorMovedI", { callback = git_blame_line.clear, group = group })

    if config.view.enable_cursor_hold then
        create_autocmd("CursorHold", { callback = git_blame_line.blame, group = group })
    end
end

function git_blame_line.blame()
    local ft = vim.fn.expand("%:h:t")
    if ft == "" or ft == "bin" then
        return
    end

    git_blame_line.clear()

    local line = vim.api.nvim_win_get_cursor(0)
    local current_file = vim.fn.expand("%")
    local blame_data = git.blame_line(current_file, line[1])

    if blame_data.error then
        vim.notify("git-blame-line: " .. blame_data.message)
        return
    end

    local opts = view.create_ext_mark_opts(blame_data.message)
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

function git_blame_line.open_diffview()
    local ft = vim.fn.expand("%:h:t")
    if ft == "" or ft == "bin" then
        return
    end

    git_blame_line.clear()

    local line = vim.api.nvim_win_get_cursor(0)
    local current_file = vim.fn.expand("%")
    local blame_data = git.blame_line(current_file, line[1])

    if blame_data.error then
        vim.notify("git-blame-line: " .. blame_data.message)
        return
    end

    local ok, diffview = pcall(require, "diffview")
    if ok then
        diffview.open(blame_data.hash)
    else
        vim.notify("git-blame-line: diffview not found")
    end
end

function git_blame_line.setup(opts)
    config.init(opts)
    view.init()

    register_commands()
    register_autocmds()
end

return git_blame_line
