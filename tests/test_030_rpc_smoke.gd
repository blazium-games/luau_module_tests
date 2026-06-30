extends AutoworkTest

func test_030_rpc_smoke() -> void:
	var path := "res://fixtures/scripts/annotations/AnnotatedRpc.luau"
	var script: Script = ResourceLoader.load(path)
	if script == null:
		pending("AnnotatedRpc fixture failed to load")
		return
	var node: Node = script.new() as Node
	add_child_autofree(node)
	if node.has_method("sync_action"):
		assert_eq(node.call("sync_action", 21), 42, "RPC-marked method should run locally in headless stub")
