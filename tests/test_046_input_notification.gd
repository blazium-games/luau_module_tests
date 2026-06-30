extends AutoworkTest

const SCRIPT_PATH := "res://fixtures/scripts/input_hook/InputHook.luau"

func test_046_input_notification() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: LuauScript = ResourceLoader.load(SCRIPT_PATH) as LuauScript
	assert_true(script != null, "Input hook fixture should load")

	var node := Node.new()
	node.set_script(script)
	add_child_autofree(node)

	var event := InputEventKey.new()
	node.call("_input", event)
	assert_true(node.get("input_seen"), "_input hook should run when invoked on script instance")
