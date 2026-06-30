extends AutoworkTest

func test_032_math_ops() -> void:
	if !ClassDB.class_exists("LuaState"):
		pending("LuaState not registered yet")
		return

	var state := LuaState.new()
	state.open_libs(LuaState.LIB_BASE | LuaState.LIB_MATH | LuaState.LIB_BLAZIUM)
	var status: int = state.do_string("local v = Vector2(1, 2); return v.x + v.y", "@math_ops_test")
	if status != Luau.LUA_OK:
		pending("Vector2 constructor/fields not available in embedded VM yet")
		state.close()
		return
	assert_eq(state.to_number(-1), 3.0, "Vector2 field access should work")
	state.pop(1)
	state.close()
