extends Spatial

onready var _navigation_mesh = find_node("AdvancedNavigationMesh3D")
onready var _lines = find_node("ImmediateGeometry")
onready var _paths = find_node("Paths")


func _ready():
	for path_node in _paths.get_children():
		var begin_node = path_node.get_node("Begin")
		var end_node = path_node.get_node("End")
		var begin_point = begin_node.global_transform.origin
		var end_point = end_node.global_transform.origin
		var paths = [
			[begin_point, end_point],
			_navigation_mesh.get_simple_path(begin_point, end_point, true),
			_navigation_mesh.get_simple_path(begin_point, end_point, false),
		]
		var path_colors = [Color.black, Color.green, Color.red]
		for i in range(paths.size()):
			var path = paths[i]
			var color = path_colors[i]
			if path != null and path.size() > 1:
				_lines.begin(Mesh.PRIMITIVE_LINE_STRIP)
				for point in path:
					_lines.set_color(color)
					_lines.set_normal(Vector3(0, 1, 0))
					_lines.add_vertex(point)
				_lines.end()
