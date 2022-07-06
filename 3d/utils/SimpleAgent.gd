extends Spatial

export var distance_to_walk := 0.0

onready var _agent = find_node("AdvancedNavigationAgent3D")
onready var _navmesh = get_node("/root").find_node("AdvancedNavigationMesh3D", true, false)


func _ready():
	_agent.connect("new_position", self, "_on_new_position")
	_agent.set_navigation_mesh(_navmesh)
	_agent.set_position(global_transform.origin)
	if distance_to_walk > 0.0:
		var target = global_transform * Vector3(0, 0, -distance_to_walk)
		_agent.set_target(target)


func _on_new_position(new_position):
	if global_transform.origin * Vector3(1, 0, 1) != new_position * Vector3(1, 0, 1):
		global_transform = global_transform.looking_at(new_position, Vector3.UP)
	global_transform.origin = new_position
