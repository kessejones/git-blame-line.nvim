local M = { }

local defaultMessage = "Not committed yet"
local gitShowFormat = '%an - %ar - %s'

local getUntrackedFiles = function()
    local cmd = "git ls-files --others --exclude-standard"
    local result = vim.fn.system(cmd)
    return vim.split(result, '%s')
end

local getGitBlameText = function(file, line)
    local blame = vim.fn.system(string.format('git blame -c -L %d,%d %s', line[1], line[1], file))
    if string.match(blame, "no such path") then
        return ""
    end

    local hash = vim.split(blame, '%s')[1]
    if hash == '000000000' then
        return defaultMessage 
    end

    local cmd = string.format('git show %s --format="%s"', hash, gitShowFormat)
    local gitShowResult = vim.fn.system(cmd)

    local text = vim.split(gitShowResult, '\n')[1]
    if text:find("fatal") then
        return "" 
    end

    return text
end

local isNewFile = function(file)
    local untrackedFiles = getUntrackedFiles()

    for _, p in ipairs(untrackedFiles) do
        if p == file then
            return true
        end
    end
    return false
end

function M.blameText(file, line)
    if isNewFile(file) then
        return defaultMessage
    end
    return getGitBlameText(file, line)
end

return M
