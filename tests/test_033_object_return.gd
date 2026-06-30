extends AutoworkTest

const OBJECT_EXTENDS_PATH := "res://fixtures/scripts/object_return/ObjectExtendsNode.luau"
const CLASS_RETURN_PATH := "res://fixtures/scripts/object_return/ClassReturnNode.luau"

func test_033_object_extends_global() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: Resource = ResourceLoader.load(OBJECT_EXTENDS_PATH)
	assert_true(script != null, "Object-return fixture should load")
	var node := script.new() as Node
	assert_true(node != null, "Object-return script should instantiate as Node")
	if "value" in node:
		assert_eq(node.get("value"), 0, "Object-return export default should resolve")

func test_034_class_helper_return() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: Resource = ResourceLoader.load(CLASS_RETURN_PATH)
	assert_true(script != null, "class() return fixture should load")
	var node := script.new() as Node
	assert_true(node != null, "class() return script should instantiate as Node")
	add_child_autofree(node)
	if "speed" in node:
		assert_eq(node.get("speed"), 7, "class() return export should resolve")
