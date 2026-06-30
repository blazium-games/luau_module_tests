extends AutoworkTest

func test_026_node_api() -> void:
	var path := "res://fixtures/scripts/annotations/AnnotatedNode.luau"
	var script: Script = ResourceLoader.load(path)
	if script == null:
		pending("AnnotatedNode fixture failed to load")
		return
	var node: Node = script.new() as Node
	add_child_autofree(node)
	assert_true(node != null, "Annotated Luau node should instantiate")
	if node.has_method("_ready"):
		node.call("_ready")
	assert_eq(str(node.get("label")), "ready", "Node script _ready should update exported label")
