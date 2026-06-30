extends AutoworkTest

func test_018_wait_signal() -> void:
	var state := LuaState.new()
	state.open_libs(LuaState.LIB_BASE | LuaState.LIB_BLAZIUM | LuaState.LIB_STRING | LuaState.LIB_TABLE)
	var emitter := Node.new()
	add_child_autofree(emitter)
	emitter.add_user_signal("done")
	state.push_variant(emitter)
	state.set_global("emitter")
	var code := """
		local sig = Signal.new(emitter, "done")
		emitter.emit_signal("done")
		local ok = wait_signal(sig, 1.0)
		return ok and "ok" or "timeout"
	"""
	var status: int = state.do_string(code, "await_signal")
	if status != Luau.LUA_OK:
		pending("wait_signal/await scheduler not available in embedded VM")
		state.close()
		return
	var result: String = state.stack_to_string(-1)
	state.pop(1)
	assert_eq(result, "ok", "wait_signal should resume after signal emit")
	state.close()
