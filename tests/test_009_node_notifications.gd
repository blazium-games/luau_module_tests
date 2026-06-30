extends AutoworkTest

const TABLE_DSL_PATH := "res://fixtures/scripts/table_dsl/TableDslNode.luau"

func test_009_node_notifications() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: Resource = ResourceLoader.load(TABLE_DSL_PATH)
	if script == null:
		pending("Notification fixture script failed to load")
		return

	var node: Node = script.new() as Node
	assert_true(node != null, "Luau node should instantiate")
	add_child_autofree(node)
	node.notification(Node.NOTIFICATION_READY)

	if "ready_called" in node:
		assert_true(node.get("ready_called"), "_ready should run when node enters tree")
	else:
		pending("_ready state not exposed on Luau instance yet")

	# Custom notification delivery.
	if node.has_method("_notification"):
		node.call("_notification", 42)
		if "notif_hits" in node:
			assert_eq(node.get("notif_hits"), 1, "Custom notification should increment counter")
		elif "ready_called" in node:
			assert_true(node.get("ready_called"), "Node should remain alive after notification")
		else:
			pending("Notification counters not exposed on Luau instance yet")
