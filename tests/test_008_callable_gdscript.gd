extends AutoworkTest

func test_008_callable_gdscript() -> void:
	var state := LuaState.new()
	state.open_libs(LuaState.LIB_BASE | LuaState.LIB_BLAZIUM)

	var holder := {"value": 0}
	var gd_callable := func(x: int) -> int:
		holder["value"] = x
		return x * 2

	state.push_variant(gd_callable)
	state.set_global("double")

	var status: int = state.do_string("return double(21)", "callable_invoke")
	assert_eq(status, Luau.LUA_OK, "Luau should call GDScript Callable")
	assert_eq(state.to_number(-1), 42.0, "Callable should return doubled value")
	assert_eq(holder["value"], 21, "Callable should receive argument from Luau")
	state.pop(1)

	status = state.do_string("function add(a, b) return a + b end", "define_add")
	assert_eq(status, Luau.LUA_OK, "Luau function definition should succeed")
	state.get_global("add")
	var lua_callable: Callable = state.to_callable(-1)
	state.pop(1)
	assert_true(lua_callable.is_valid(), "Luau function should convert to Callable")
	assert_eq(lua_callable.call(10, 32), 42, "Godot should invoke Luau function via Callable")

	state.close()
