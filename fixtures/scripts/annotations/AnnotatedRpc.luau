-- AnnotatedRpc.luau: @rpc metadata
--- @class AnnotatedRpc
--- @extends Node
local AnnotatedRpc = {
	extends = "Node",
	class_name = "AnnotatedRpc",
}
local AnnotatedRpc_C = gdclass(AnnotatedRpc)

--- @rpc sync_action 0 0 false
function AnnotatedRpc:sync_action(value: number)
	return value * 2
end

return AnnotatedRpc_C
