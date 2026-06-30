extends AutoworkTest

func test_013_luau_state_from_gdscript() -> void:
	# Orchestrate an embedded VM entirely from GDScript (modding / runtime eval pattern).
	var results: Array = []

	var state := LuaState.new()
	state.open_libs(LuaState.LIB_BASE | LuaState.LIB_BLAZIUM | LuaState.LIB_MATH)

	state.push_variant({"max_health": 100, "health": 100})
	state.set_global("player")

	var status: int = state.do_string("player.health = player.health - 10", "modify_player")
	assert_eq(status, Luau.LUA_OK, "GDScript-driven VM should mutate pushed variant table")
	state.pop(state.get_top())

	state.get_global("player")
	var player: Dictionary = state.to_dictionary(-1)
	state.pop(1)
	assert_eq(player["health"], 90, "Health should decrease after Luau mutation")

	status = state.do_string("return player.health + player.max_health", "read_player")
	assert_eq(status, Luau.LUA_OK, "GDScript-driven VM should read globals")
	results.append(state.to_number(-1))
	state.pop(1)

	state.push_variant(func(x: int) -> int:
		return x + 5
	)
	state.set_global("add_five")
	status = state.do_string("return add_five(7)", "callable_roundtrip")
	assert_eq(status, Luau.LUA_OK, "Callable round-trip through GDScript VM should work")
	results.append(state.to_number(-1))
	state.pop(1)

	assert_eq(results[0], 190.0, "Combined player stats should be readable")
	assert_eq(results[1], 12.0, "Callable should add five to seven")

	state.close()
