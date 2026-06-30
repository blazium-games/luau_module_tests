extends AutoworkTest

func test_002_compile_and_sandbox() -> void:
	var state := LuaState.new()
	state.open_libs()

	var bytecode: PackedByteArray = Luau.compile("return 42", null)
	assert_true(bytecode.size() > 0, "Luau.compile should produce bytecode")

	var loaded: bool = state.load_bytecode(bytecode, "sandbox_chunk")
	assert_true(loaded, "Bytecode should load onto the stack")
	assert_true(state.is_function(-1), "Loaded chunk should be a function")

	state.sandbox()

	var status: int = state.pcall(0, 1)
	assert_eq(status, Luau.LUA_OK, "Sandboxed pcall should succeed")
	assert_eq(state.to_number(-1), 42.0, "Sandboxed chunk should return 42")
	state.pop(1)

	# After sandbox, mutating builtins should fail at runtime.
	status = state.do_string("string.byte = nil", "mutate_stdlib")
	assert_false(status == Luau.LUA_OK, "Mutating stdlib after sandbox should fail")
	if state.get_top() > 0:
		state.pop(state.get_top())

	assert_true(state.is_valid(), "State should remain valid after sandboxed execution errors")
	state.close()
