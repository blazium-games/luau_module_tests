extends AutoworkTest

func test_003_variant_bindings() -> void:
	var state := LuaState.new()
	state.open_libs(LuaState.LIB_BLAZIUM | LuaState.LIB_BASE | LuaState.LIB_MATH)

	state.push_variant(Vector2(3, 4))
	state.set_global("v2")
	var status: int = state.do_string("return v2.x + v2.y", "vector2")
	assert_eq(status, Luau.LUA_OK, "Vector2 binding should be callable from Luau")
	assert_eq(state.to_number(-1), 7.0, "Vector2 components should sum correctly")
	state.pop(1)

	state.push_variant(Color(0.25, 0.5, 0.75, 1.0))
	state.set_global("c")
	status = state.do_string("return c.r + c.g + c.b", "color")
	assert_eq(status, Luau.LUA_OK, "Color binding should be callable from Luau")
	assert_eq(state.to_number(-1), 1.5, "Color channels should sum correctly")
	state.pop(1)

	state.push_variant([1, 2, 3])
	state.set_global("arr")
	status = state.do_string("return #arr", "array_len")
	assert_eq(status, Luau.LUA_OK, "Array binding should be usable in Luau")
	assert_eq(state.to_integer(-1), 3, "Array length should be 3")
	state.pop(1)

	state.push_variant({"a": 1, "b": 2})
	state.set_global("dict")
	status = state.do_string("return dict.a + dict.b", "dictionary")
	assert_eq(status, Luau.LUA_OK, "Dictionary binding should be usable in Luau")
	assert_eq(state.to_number(-1), 3.0, "Dictionary values should be readable")
	state.pop(1)

	state.close()
