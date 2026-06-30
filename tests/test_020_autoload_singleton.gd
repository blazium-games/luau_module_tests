extends AutoworkTest

func test_020_autoload_singleton() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	if !ClassDB.class_exists("LuaState"):
		pending("LuaState not registered yet")
		return

	var autoload: Node = null
	if is_inside_tree():
		autoload = get_tree().root.get_node_or_null("LuauAutoload")
	if autoload == null:
		pending("LuauAutoload node not set up by run_tests")
		return

	assert_true(autoload.get_script() != null, "Autoload should have Luau script attached")

	var lang := LuauScriptLanguage.get_singleton()
	if lang:
		lang.add_global_constant("LuauAutoload", autoload)

	var state := LuaState.new()
	state.open_libs()
	var status: int = state.do_string("return LuauAutoload ~= nil", "autoload_check")
	assert_eq(status, Luau.LUA_OK, "Autoload global check should compile")
	assert_true(state.to_boolean(-1), "LuauAutoload global should exist in embedded VM")
	state.pop(1)
	state.close()
