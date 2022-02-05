local strf = string.format
local config = require("git-blame-line.config")

local git = {}

local function run_cmd(cmd)
    return vim.fn.system(table.concat(cmd, " "))
end

local untracked_files = function()
    local result = run_cmd({ "git", "ls-files", "--others", "--exclude-standard" })
    return vim.split(result, "%s")
end

local run_git_blame = function(file, line)
    local blame = run_cmd({ "git", "blame", "-c", "-L", strf("%d,%d", line[1], line[1]), file })
    if string.match(blame, "no such path") then
        return ""
    end

    local hash = vim.split(blame, "%s")[1]
    if hash == "000000000" then
        return config.git.default_message
    end

    local git_show_result = run_cmd({ "git", "show", hash, strf('--format="%s"', config.git.blame_format) })
    local text = vim.split(git_show_result, "\n")[1]
    if text:find("fatal") then
        return ""
    end

    return text
end

local is_new_file = function(file)
    local _untracked_files = untracked_files()

    for _, p in ipairs(_untracked_files) do
        if p == file then
            return true
        end
    end
    return false
end

function git.blame_line(file, line)
    if is_new_file(file) then
        return config.git.default_message
    end
    return run_git_blame(file, line)
end

return git
