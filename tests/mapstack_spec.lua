local find_mapping = function (maps, lhs)
    for _, map in ipairs(maps) do
        if map.lhs == lhs then
            return map
        end
    end
end

describe("stackmap", function ()
    it("can be required", function ()
        require("stackmap")
    end)

    it("can push a single mapping", function ()
        require("stackmap").push("test1", "n", {
            asdf = "echo 'This is a test'",
        })

        local maps = vim.api.nvim_get_keymap('n')
        local found = find_mapping(maps, "asdf")
        assert.are.same("echo 'This is a test'", found.rhs)
    end)

    it("can push multiple mappings", function ()
        local rhs = "echo 'This is a test'"
        require("stackmap").push("test1", "n", {
            ["asdf_1"] = rhs .. "1",
            ["asdf_2"] = rhs .. "2",
        })

        local maps = vim.api.nvim_get_keymap('n')
        local found_1 = find_mapping(maps, "asdf_1")
        assert.are.same(rhs .. "1", found_1.rhs)
        local found_2 = find_mapping(maps, "asdf_2")
        assert.are.same(rhs .. "2", found_2.rhs)
    end)
end)
