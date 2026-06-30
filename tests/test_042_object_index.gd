extends AutoworkTest

func test_042_object_index() -> void:
	if !ClassDB.class_exists("LuaState"):
		pending("LuaState not registered yet")
		return

	var state := LuaState.new()
	state.open_libs(LuaState.LIB_BASE | LuaState.LIB_BLAZIUM)

	var node := Node.new()
	node.name = "ObjIndex"
	add_child_autofree(node)

	state.push_variant(node)
	state.set_global("obj")

	var status: int = state.do_string(
		'assert(obj.name == "ObjIndex")\n' +
		'local parent = obj.get_parent\n' +
		'assert(parent ~= nil)\n' +
		'return true',
		"@object_index"
	)
	assert_eq(status, Luau.LUA_OK, "Object __index should resolve ClassDB properties and methods")
	state.close()
