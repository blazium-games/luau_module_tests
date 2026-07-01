extends AutoworkTest

func test_027_super_call() -> void:
	ResourceLoader.load("res://fixtures/scripts/annotations/AnnotatedNode.luau")
	var path := "res://fixtures/scripts/annotations/AnnotatedInheritance.luau"
	var script: Script = ResourceLoader.load(path)
	if script == null:
		pending("AnnotatedInheritance fixture failed to load")
		return
	var node: Node = script.new() as Node
	add_child_autofree(node)
	assert_true(node != null, "AnnotatedChild Luau node should instantiate")
	node.notification(Node.NOTIFICATION_READY)
	assert_eq(str(node.get("label")), "ready_child", "super._ready should chain to base")
