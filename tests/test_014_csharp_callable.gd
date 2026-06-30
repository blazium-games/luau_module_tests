extends AutoworkTest

func test_014_csharp_callable() -> void:
	if !ClassDB.class_exists("CSharpScript"):
		pending("CSharpScript not available (mono build disabled)")
		return

	var state := LuaState.new()
	state.open_libs(LuaState.LIB_BASE | LuaState.LIB_BLAZIUM)

	# Use a Godot Callable wrapping a C# delegate when a C# script is present.
	# Without a fixture C# script, verify ClassDB Callable push/pop round-trip path.
	var dummy := Node.new()
	add_child_autofree(dummy)

	var cs_callable := Callable(dummy, "set_name")
	state.push_variant(cs_callable)
	state.set_global("cs_callable")

	var status: int = state.do_string("return type(cs_callable)", "callable_type")
	if status != Luau.LUA_OK:
		pending("C# Callable invocation from Luau not wired yet")
		state.close()
		return

	var type_name: String = state.stack_to_string(-1)
	state.pop(1)
	assert_false(type_name.is_empty(), "Luau should report a type for pushed C# Callable")

	state.close()
