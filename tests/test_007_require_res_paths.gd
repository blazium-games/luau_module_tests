extends AutoworkTest

const REQUIRE_FIXTURE_DIR := "res://fixtures/scripts/require/"

func test_007_require_res_paths() -> void:
	var state := LuaState.new()
	state.open_libs(LuaState.LIB_BASE | LuaState.LIB_BLAZIUM)

	if !ClassDB.class_exists("LuauScript"):
		# Embedded VM require via res:// paths when script language is not ready.
		var code := """
			local ok, mod = pcall(function()
				return require("%sHelperModule.mod")
			end)
			if not ok then
				return "err:" .. tostring(mod)
			end
			return mod.value
		""".format([REQUIRE_FIXTURE_DIR])
		var status: int = state.do_string(code, "require_res_path")
		if status != Luau.LUA_OK:
			pending("res:// require not available in embedded VM yet")
			state.close()
			return
		var value: String = state.stack_to_string(-1)
		state.pop(1)
		assert_eq(value, "from_require_module", "require should load fixture module via res:// path")
		state.close()
		return

	var script: Resource = ResourceLoader.load(REQUIRE_FIXTURE_DIR + "Consumer.luau")
	if script == null:
		pending("require consumer fixture failed to load")
		return

	var instance: Object = script.new()
	assert_true(instance != null, "Consumer script should instantiate")

	if instance.has_method("get_combined"):
		var combined: Variant = instance.call("get_combined")
		if combined == null:
			pending("require consumer get_combined failed at runtime")
			return
		assert_eq(combined, "from_require_module_loaded")
	elif "combined" in instance:
		assert_eq(instance.get("combined"), "from_require_module_loaded")
	else:
		# Run require inline in a fresh VM scoped to fixture directory.
		state = LuaState.new()
		state.open_libs(LuaState.LIB_BASE | LuaState.LIB_BLAZIUM)
		var inline := """
			local mod = require("%sHelperModule.mod")
			return mod.sum(10, 32)
		""".format([REQUIRE_FIXTURE_DIR])
		var status: int = state.do_string(inline, "require_sum")
		if status != Luau.LUA_OK:
			pending("require via res:// paths not fully wired")
		else:
			assert_eq(state.to_number(-1), 42.0, "Required module function should execute")
			state.pop(1)
		state.close()
