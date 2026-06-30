extends AutoworkTest

func test_040_validate_error_line() -> void:
	var lang = LuauScriptLanguage.get_singleton()
	if lang == null:
		pending("LuauScriptLanguage not registered yet")
		return

	var source := "local ok = 1\nlocal bad =\nreturn ok"
	var errors: Array[Dictionary] = []
	var ok: bool = lang.validate(source, "res://bad.luau", null, errors)
	assert_false(ok, "Invalid source should fail validation")
	assert_true(errors.size() > 0, "Validation should report errors")
	assert_true(int(errors[0].get("line", 1)) >= 2, "Compile error should report the failing line")
