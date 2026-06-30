extends AutoworkTest

const BYTECODE_FIXTURE := "res://fixtures/scripts/table_dsl/TableDslNode.luauc"
const SOURCE_FIXTURE := "res://fixtures/scripts/table_dsl/TableDslNode.luau"

func test_015_bytecode_export() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	if ResourceLoader.exists(BYTECODE_FIXTURE):
		var bytecode_script: Resource = ResourceLoader.load(BYTECODE_FIXTURE)
		assert_true(bytecode_script != null, "Pre-exported .luauc sidecar should load")
		if bytecode_script.get_class() == "LuauScript":
			var instance: Object = bytecode_script.new()
			assert_true(instance != null, "Bytecode-exported script should instantiate")
			add_child_autofree(instance as Node)
		return

	# Fallback: verify compile produces bytecode suitable for export sidecars.
	var source := FileAccess.get_file_as_string(SOURCE_FIXTURE)
	assert_false(source.is_empty(), "Source fixture should exist for bytecode export smoke test")

	var bytecode: PackedByteArray = Luau.compile(source, null)
	assert_true(bytecode.size() > 0, "Source fixture should compile to non-empty bytecode")

	if ClassDB.class_exists("EditorExportPlugin"):
		pending("No pre-exported .luauc fixture; compile smoke passed — run EditorExportLuau to generate sidecars")
	else:
		pending("No pre-exported .luauc fixture; compile smoke passed")
