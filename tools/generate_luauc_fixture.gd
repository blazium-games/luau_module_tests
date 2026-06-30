extends SceneTree

func _init() -> void:
	var source_path := "res://fixtures/scripts/table_dsl/TableDslNode.luau"
	var out_path := "res://fixtures/scripts/table_dsl/TableDslNode.luauc"
	var source := FileAccess.get_file_as_string(source_path)
	if source.is_empty():
		push_error("Missing source fixture: %s" % source_path)
		quit(1)
		return

	var bytecode: PackedByteArray = Luau.compile(source, null)
	if bytecode.is_empty():
		push_error("Failed to compile fixture")
		quit(1)
		return

	var file := FileAccess.open(out_path, FileAccess.WRITE)
	file.store_buffer(bytecode)
	file.close()
	print("Wrote ", out_path, " (", bytecode.size(), " bytes)")
	quit()
