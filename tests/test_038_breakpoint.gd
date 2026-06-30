extends AutoworkTest

func test_038_breakpoint_source_match() -> void:
	if !ClassDB.class_exists("LuauScriptLanguage"):
		pending("LuauScriptLanguage not registered yet")
		return

	if !ClassDB.class_exists("EngineDebugger"):
		pending("EngineDebugger not available in this build")
		return

	var path := "res://fixtures/scripts/math/ScriptVector2Node.luau"
	EngineDebugger.insert_breakpoint(3, path)

	var lang := LuauScriptLanguage.get_singleton()
	EngineDebugger.insert_breakpoint(3, path)
	assert_true(lang.debug_should_break_at("@" + path, 3), "Debugger should match editor breakpoints by normalized source path")
	EngineDebugger.remove_breakpoint(3, path)
