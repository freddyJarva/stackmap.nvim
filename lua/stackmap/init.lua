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
            existing_maps[lhs] = existing_map
        end
    end

    M._stack[name] = M._stack[name] or {}
    M._stack[name][mode] = {
        existing = existing_maps,
        mappings = mappings,
    }

    for lhs, rhs in pairs(mappings) do
        -- TODO: pass options
        vim.keymap.set(mode, lhs, rhs)
    end
end

M.pop = function (name, mode)
    local state = M._stack[name][mode]
    M._stack[name][mode] = nil
    if state then
        for lhs, rhs in pairs(state.mappings) do
            if state.existing[lhs] then
                local og_mapping = state.existing[lhs]
                vim.keymap.set(mode, lhs, og_mapping.rhs, og_mapping.opts)
            else
                vim.keymap.del(mode, lhs)
            end
        end
    end
end

M._clear = function ()
    M._stack = {}
end

return M
