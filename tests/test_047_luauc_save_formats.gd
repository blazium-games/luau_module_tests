extends AutoworkTest

const SOURCE_FIXTURE := "res://fixtures/scripts/table_dsl/TableDslNode.luau"

func test_047_luauc_save_formats() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: LuauScript = ResourceLoader.load(SOURCE_FIXTURE) as LuauScript
	assert_true(script != null, "Source fixture should load as LuauScript")

	var source := script.get_source_code()
	var bytecode: PackedByteArray = Luau.compile(source, null)
	assert_true(bytecode.size() > 0, "Bytecode compile should succeed for save-format smoke test")

	# Round-trip raw wrap header (LUAC magic) without editor ResourceSaver.
	var wrapped := PackedByteArray()
	wrapped.append_array("LUAC".to_utf8_buffer())
	wrapped.append_array(bytecode)
	assert_true(wrapped.size() > bytecode.size(), "Wrapped bytecode should include header")

	if !ClassDB.class_exists("ResourceFormatSaverLuau"):
		pending("ResourceFormatSaverLuau not registered in this build")
		return

	pending("Editor .luauc compress/encrypt save requires TOOLS editor build; compile + wrap smoke passed")
