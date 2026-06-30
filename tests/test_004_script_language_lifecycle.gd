extends AutoworkTest

func test_004_script_language_lifecycle() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	assert_true(ClassDB.class_exists("LuauScriptLanguage"), "LuauScriptLanguage must be registered")

	var script: Resource = ClassDB.instantiate("LuauScript")
	var source := "return 99"
	script.set_source_code(source)
	assert_eq(script.get_source_code(), source, "Source code should round-trip")

	var bytecode: PackedByteArray = script.compile()
	assert_true(bytecode.size() > 0, "LuauScript.compile should produce bytecode")

	var state := LuaState.new()
	state.open_libs()
	state.load_bytecode(bytecode, "lifecycle_test")
	var status: int = state.pcall(0, 1)
	assert_eq(status, Luau.LUA_OK, "Compiled LuauScript bytecode should execute")
	assert_eq(state.to_number(-1), 99.0, "Script return value should match source")
	state.pop(1)
	state.close()

	script.set_source_code("return 100")
	bytecode = script.compile(true)
	state = LuaState.new()
	state.open_libs()
	state.load_bytecode(bytecode, "lifecycle_recompile")
	status = state.pcall(0, 1)
	assert_eq(status, Luau.LUA_OK, "Recompiled bytecode should execute")
	assert_eq(state.to_number(-1), 100.0, "Updated script should return new value")
	state.pop(1)
	state.close()
