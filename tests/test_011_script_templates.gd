extends AutoworkTest

func test_011_script_templates() -> void:
	if !ClassDB.class_exists("LuauScriptLanguage"):
		pending("LuauScriptLanguage not registered yet")
		return

	var language: ScriptLanguage = ClassDB.instantiate("LuauScriptLanguage") as ScriptLanguage
	assert_true(language != null, "LuauScriptLanguage should instantiate")

	var templates: Array = language.get_built_in_templates("")
	assert_true(templates.size() >= 2, "Should provide templates for both syntax formats")

	var found_table_dsl := false
	var found_gdclass := false
	for entry in templates:
		var text: String = entry.get("content", "")
		if text.contains("extends =") or text.contains("export("):
			found_table_dsl = true
		if text.contains("gdclass") or text.contains("@class"):
			found_gdclass = true

	assert_true(found_table_dsl, "Built-in templates should include table DSL syntax")
	assert_true(found_gdclass, "Built-in templates should include gdclass syntax")
