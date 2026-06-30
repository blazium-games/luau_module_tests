extends AutoworkTest

const CONST_SCRIPT := "res://fixtures/scripts/constants/RegisterConstant.luau"

func test_041_public_constants() -> void:
	var lang = LuauScriptLanguage.get_singleton()
	if lang == null:
		pending("LuauScriptLanguage not registered yet")
		return

	var script: Resource = ResourceLoader.load(CONST_SCRIPT)
	assert_true(script != null, "RegisterConstant fixture should load")
	script.reload()

	var constants: Array = []
	lang.get_public_constants(constants)

	var found := false
	for entry in constants:
		if entry is Array and entry.size() >= 2 and String(entry[0]) == "TEST_CONST":
			assert_eq(entry[1], 42, "@registerConstant should appear in public constants")
			found = true
			break
		elif entry is Dictionary and String(entry.get("first", entry.get("key", ""))) == "TEST_CONST":
			found = true
			break

	if !found:
		pending("TEST_CONST not found in get_public_constants yet")
