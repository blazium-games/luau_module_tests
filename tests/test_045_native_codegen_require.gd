extends AutoworkTest

const SCRIPT_PATH := "res://fixtures/scripts/native_require/NativeRequireConsumer.luau"

func test_045_native_codegen_require() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: LuauScript = ResourceLoader.load(SCRIPT_PATH) as LuauScript
	assert_true(script != null, "Native require consumer should load")

	var node := Node.new()
	node.set_script(script)
	add_child_autofree(node)

	assert_eq(node.call("load_native"), 42, "require of --!native module should return expected value")
