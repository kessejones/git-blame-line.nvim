local config = require("git-blame-line.config")
local utils = require("git-blame-line.utils")

local git = {}

local function run_job(cmd)
    local output = {}
    local job_id = vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if #data > 0 and data[1] ~= "" then
                output = data
            end
        end,
    })

    vim.fn.jobwait({ job_id })

    return output
end

function git.untracked_files()
    return run_job({ "git", "ls-files", "--others", "--exclude-standard" })
end

function git.show(hash, format)
    return run_job({ "git", "show", hash, string.format('--format="%s"', format) })
end

function git.blame(filename, line_start, line_end)
    return run_job({ "git", "blame", "-c", "-L", string.format("%d,%d", line_start, line_end), filename })
end

function git.blame_line(filename, line)
    local untracked_files = git.untracked_files()
    if utils.contains(untracked_files, filename) then
        return {
            error = false,
            message = config.git.default_message,
        }
    end

    local blame_result = git.blame(filename, line, line)
    local blame = table.concat(blame_result)
    if string.match(blame, "no such path") then
        return {
            error = true,
            message = "",
        }
    end
    local hash = vim.split(blame, "%s")[1]
    if hash == "00000000" then
        return {
            error = false,
            message = config.git.default_message,
        }
    end

    local git_show_result = git.show(hash, config.git.blame_format)
    local text = vim.fn.trim(git_show_result[1], '"')

    if text:find("fatal") or text == "" then
        return {
            error = true,
            hash = hash,
            message = text,
        }
    end

    return {
        error = false,
        hash = hash,
        message = text,
    }
end

return git
