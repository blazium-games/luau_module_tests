extends AutoworkTest

const SCRIPT_PATH := "res://fixtures/scripts/placeholder_tool/ToolPlaceholder.luau"

func test_044_placeholder_tool() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: LuauScript = ResourceLoader.load(SCRIPT_PATH) as LuauScript
	assert_true(script != null, "Tool placeholder fixture should load")
	assert_true(script.is_tool(), "Fixture should be a tool script")

	var good_source := script.get_source_code()
	script.set_source_code("this is not valid luau {{{")
	var reload_err: Error = script.reload(true)
	assert_ne(reload_err, OK, "Invalid reload should fail")
	assert_true(script.is_placeholder_fallback_enabled(), "@tool script should enable placeholder fallback on failed reload")

	script.set_source_code(good_source)
	reload_err = script.reload(true)
	assert_eq(reload_err, OK, "Valid reload should succeed")
	assert_false(script.is_placeholder_fallback_enabled(), "Placeholder fallback should clear after successful reload")
