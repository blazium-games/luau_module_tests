extends AutoworkTest

func test_040_validate_error_line() -> void:
	var lang = LuauScriptLanguage.get_singleton()
	if lang == null:
		pending("LuauScriptLanguage not registered yet")
		return

	var source := "local ok = 1\nlocal bad =\nreturn ok"
	var result: Dictionary = lang.validate(source, "res://bad.luau")
	assert_false(bool(result.get("valid", true)), "Invalid source should fail validation")
	var errors: Array = result.get("errors", [])
	assert_true(errors.size() > 0, "Validation should report errors")
	var error_line: int = int(errors[0].get("line", -1))
	assert_true(error_line > 0, "Compile error should report the failing line (got %d)" % error_line)
