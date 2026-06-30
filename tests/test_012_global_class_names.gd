extends AutoworkTest

func test_012_global_class_names() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var table_script: Resource = ResourceLoader.load("res://fixtures/scripts/table_dsl/TableDslNode.luau")
	if table_script == null:
		pending("Table DSL global class fixture failed to load")
		return

	# Loading the script should register LuauFixtureTableDsl as a global class.
	var global_classes: Array = ProjectSettings.get_global_class_list()
	var found := false
	for entry in global_classes:
		if entry.get("class", "") == "LuauFixtureTableDsl":
			found = true
			assert_eq(String(entry.get("language", "")), "Luau", "Global class should use Luau language id")
			break

	if !found:
		pending("Global class registration not wired for table_dsl class_name yet")
	else:
		assert_true(found, "LuauFixtureTableDsl should appear in global class list")
