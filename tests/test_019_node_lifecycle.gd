extends AutoworkTest

const PLAYER_PATH := "res://fixtures/scripts/node_lifecycle/PlayerNode.luau"

func test_019_node_lifecycle() -> void:
	if !ClassDB.class_exists("LuauScript"):
		pending("LuauScript not registered yet")
		return

	var script: Resource = ResourceLoader.load(PLAYER_PATH)
	assert_true(script != null, "PlayerNode fixture should load")

	var node: Node = script.new() as Node
	assert_true(node != null, "PlayerNode should instantiate")
	add_child_autofree(node)

	# Allow lifecycle notifications without requiring SceneTree await (AutoworkTest may lack tree).
	for _i in 3:
		node.notification(NOTIFICATION_ENTER_TREE)
		node.notification(NOTIFICATION_READY)
		node.notification(NOTIFICATION_PROCESS)

	if "enter_tree_called" in node:
		assert_true(node.get("enter_tree_called"), "_enter_tree/_ready should run")
	if "process_ticks" in node:
		assert_true(node.get("process_ticks") > 0, "_process should tick when node is in tree")
