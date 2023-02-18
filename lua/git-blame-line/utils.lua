local utils = {}

function utils.contains(list, item)
    for _, value in pairs(list) do
        if value == item then
            return true
        end
    end
    return false
end

return utils
