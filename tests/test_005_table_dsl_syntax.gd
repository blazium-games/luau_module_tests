extends AutoworkTest

const TABLE_DSL_PATH := "res://fixtures/scripts/table_dsl/TableDslNode.luau"

func test_005_table_dsl_syntax() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: Resource = ResourceLoader.load(TABLE_DSL_PATH)
	assert_true(script != null, "Table DSL fixture should load as a resource")
	assert_eq(script.get_class(), "LuauScript", "Fixture should be a LuauScript resource")

	if !script.can_instantiate():
		pending("Table DSL script loaded but cannot instantiate yet")
		return

	var instance: Object = script.new()
	assert_true(instance != null, "Table DSL script should instantiate")
	add_child_autofree(instance as Node)

	if instance.has_method("get_speed"):
		assert_eq(instance.call("get_speed"), 42, "Exported speed property should default to 42")
	elif "speed" in instance:
		assert_eq(instance.get("speed"), 42, "Exported speed property should default to 42")
	else:
		pending("Table DSL export properties not yet exposed on instance")
