extends AutoworkTest

func test_001_luau_state_vm() -> void:
	assert_true(ClassDB.class_exists("LuaState"), "LuaState must be registered")
	assert_true(ClassDB.class_exists("Luau"), "Luau compiler must be registered")

	var state := LuaState.new()
	state.open_libs()

	var status: int = state.do_string("return 1 + 2", "arithmetic")
	assert_eq(status, Luau.LUA_OK, "do_string should compile and run")
	assert_true(state.is_number(-1), "Result should be numeric")
	assert_eq(state.to_number(-1), 3.0, "1 + 2 should equal 3")
	state.pop(1)

	status = state.do_string("return { key = 'value', num = 42 }", "table_return")
	assert_eq(status, Luau.LUA_OK, "Table return should succeed")
	var result: Variant = state.to_variant(-1)
	state.pop(1)
	assert_eq(result["key"], "value", "Dictionary key should round-trip")
	assert_eq(result["num"], 42, "Dictionary number should round-trip")

	state.close()
