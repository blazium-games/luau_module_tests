extends AutoworkTest

const TABLE_DSL_PATH := "res://fixtures/scripts/table_dsl/TableDslNode.luau"
const GDCLASS_PATH := "res://fixtures/scripts/gdclass/GdclassNode.luau"

func test_010_export_properties() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var table_script: Resource = ResourceLoader.load(TABLE_DSL_PATH)
	var gdclass_script: Resource = ResourceLoader.load(GDCLASS_PATH)
	if table_script == null or gdclass_script == null:
		pending("Export fixture scripts failed to load")
		return

	var table_node: Object = table_script.new()
	var gdclass_node: Object = gdclass_script.new()
	add_child_autofree(table_node as Node)
	add_child_autofree(gdclass_node as Node)

	assert_exports(table_node, "speed", TYPE_INT)
	assert_exports(table_node, "label", TYPE_STRING)
	assert_exports(gdclass_node, "speed", TYPE_INT)
	assert_exports(gdclass_node, "label", TYPE_STRING)
