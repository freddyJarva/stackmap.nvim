local find_mapping = function (lhs)
    local maps = vim.api.nvim_get_keymap('n')
    for _, map in ipairs(maps) do
        if map.lhs == lhs then
            return map
        end
    end
end

describe("stackmap", function ()
    before_each(function ()
        pcall(vim.keymap.del, "n", "asdf")
        require("stackmap")._clear()
    end)
    it("can be required", function ()
        require("stackmap")
    end)

    it("can push a single mapping", function ()
        require("stackmap").push("test1", "n", {
            asdf = "echo 'This is a test'",
        })

        local found = find_mapping("asdf")
        assert.are.same("echo 'This is a test'", found.rhs)
    end)

    it("can push multiple mappings", function ()
        local rhs = "echo 'This is a test'"
        require("stackmap").push("test1", "n", {
            ["asdf_1"] = rhs .. "1",
            ["asdf_2"] = rhs .. "2",
        })

        local found_1 = find_mapping("asdf_1")
        assert.are.same(rhs .. "1", found_1.rhs)
        local found_2 = find_mapping("asdf_2")
        assert.are.same(rhs .. "2", found_2.rhs)
    end)

    it("can delete mappings after pop: no existing", function ()
        require("stackmap").push("test1", "n", {
            asdf = "echo 'This is a test'",
        })
        local found = find_mapping("asdf")
        assert.are.same("echo 'This is a test'", found.rhs)


        require("stackmap").pop("test1", "n")
        local after_pop = find_mapping("asdf")
        assert.are.same(nil, after_pop)
    end)

    it("can delete mappings after pop: existing", function ()
        vim.keymap.set('n', 'asdf', "OG MAPPING")

        require("stackmap").push("test1", "n", {
            asdf = "echo 'This is another test'",
        })
        local found_2 = find_mapping("asdf")
        assert.are.same("echo 'This is another test'", found_2.rhs)

        require("stackmap").pop("test1", "n")
        local after_pop = find_mapping("asdf")
        assert.are.same("OG MAPPING", after_pop.rhs)
    end)
end)
