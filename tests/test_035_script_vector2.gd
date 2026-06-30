extends AutoworkTest

const SCRIPT_MATH_PATH := "res://fixtures/scripts/math/ScriptVector2Node.luau"

func test_035_script_vector2() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: Resource = ResourceLoader.load(SCRIPT_MATH_PATH)
	assert_true(script != null, "Script math fixture should load")

	var node: Node = script.new() as Node
	assert_true(node != null, "Script math fixture should instantiate")
	add_child_autofree(node)

	if node.has_method("get_vector_sum"):
		assert_eq(node.call("get_vector_sum"), 3, "Vector2 should work on script class VMs")
	else:
		pending("get_vector_sum not exposed on script instance yet")
