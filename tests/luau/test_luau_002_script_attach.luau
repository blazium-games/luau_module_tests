local Test = {
	extends = "AutoworkTest",
	test_luau_script_attach = function(self)
		if not ClassDB.class_exists("LuauScript") then
			return
		end
		local script = ResourceLoader.load("res://fixtures/scripts/table_dsl/TableDslNode.luau")
		if script == nil then
			error("Table DSL fixture should load")
		end
		local node = script:new()
		if node == nil then
			error("Luau script should instantiate a node")
		end
	end,
}

return Test
