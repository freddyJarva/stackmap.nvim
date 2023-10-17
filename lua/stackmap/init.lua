local M = {}

local find_mapping = function (maps, lhs)
    for _, value in ipairs(maps) do
        if value.lhs == lhs then
            return value
        end
    end
end

M._stack = {}

M.push = function (name, mode, mappings)
    local maps = vim.api.nvim_get_keymap(mode)

    local existing_maps = {}
    for lhs, rhs in pairs(mappings) do
        local existing_map = find_mapping(maps, lhs)

        if existing_map then
            table.insert(existing_maps, existing_map)
        end
    end

    M._stack[name] = existing_maps

    for lhs, rhs in pairs(mappings) do
        -- TODO: pass options
        vim.keymap.set(mode, lhs, rhs)
    end
end

M.pop = function (name)
end

return M
