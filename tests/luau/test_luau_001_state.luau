local Test = {
	extends = "AutoworkTest",
	test_luau_state_smoke = function(self)
		if not ClassDB.class_exists("LuauState") then
			return
		end
		local state = LuauState.new()
		state:open_libraries()
		local result = state:do_string("return 2 + 2")
		if result ~= 4 then
			error("LuauState should evaluate arithmetic")
		end
	end,
}

return Test
