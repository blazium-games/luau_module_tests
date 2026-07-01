extends AutoworkTest

const LOOKUP_PATH := "res://fixtures/scripts/lookup/LookupTarget.luau"

func test_036_lookup_member_line() -> void:
	if !ClassDB.class_exists("LuauScriptLanguage"):
		pending("LuauScriptLanguage not registered yet")
		return

	var lang: ScriptLanguage = LuauScriptLanguage.get_singleton()
	var source := FileAccess.get_file_as_string(LOOKUP_PATH)
	assert_false(source.is_empty(), "Lookup fixture source should exist")

	var line: int = lang.find_function("get_speed", source)
	assert_eq(line, 3, "find_function should return the member definition line")
