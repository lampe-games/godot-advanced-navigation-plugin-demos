extends "res://addons/gut/test.gd"

const EPSILON = 0.01
const EPSILON3 = Vector3(0.01, 0.01, 0.01)

# TODO: move those to GUT maybe and add proper prints(?)


func assert_almost_eq_v3(vec_a, vec_b):
	"""GUT has some problems with Vec3 arrays"""
	assert_almost_eq(vec_a, vec_b, EPSILON3)
	# just in case (seen some problems with that):
	assert_almost_eq(vec_a.x, vec_b.x, EPSILON)
	assert_almost_eq(vec_a.y, vec_b.y, EPSILON)
	assert_almost_eq(vec_a.z, vec_b.z, EPSILON)


func assert_almost_eq_v3arr(array_a, array_b):
	"""GUT has some problems with Vec3 arrays"""
	assert_eq(array_a.size(), array_b.size())
	if array_a.size() == array_b.size():
		for i in range(array_a.size()):
			assert_almost_eq_v3(array_a[i], array_b[i])


func test_server_is_present():
	assert_true(AdvancedNavigationServer3D is Node)


func test_empty_detour_navigation_mesh_created():
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	# assert_ne(navmesh, null)	# GUT bug
	assert_true(navmesh != null)


func test_detour_navigation_mesh_built():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	assert_true(input_geometry != null)
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources([plane_mesh])

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	assert_true(recast_config != null)
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()
	assert_true(detour_config != null)

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	assert_true(navmesh != null)
	assert_true(navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config))


func test_get_closest_point_failed():
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	assert_almost_eq_v3(navmesh.get_closest_point(Vector3.ZERO), Vector3.INF)


func test_get_closest_point_succeeded():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources([plane_mesh])

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)
	assert_almost_eq_v3(navmesh.get_closest_point(Vector3(0, 5, 0)), Vector3(0, 0.2, 0))
	assert_almost_eq_v3(navmesh.get_closest_point(Vector3(-10, 0, -10)), Vector3(-4.1, 0.2, -4.1))
	assert_almost_eq_v3(navmesh.get_closest_point(Vector3(10, 0, 10), null), Vector3(4, 0.2, 4))


func test_get_closest_point_with_extents_failed():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources([plane_mesh])

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)
	assert_almost_eq_v3(
		navmesh.get_closest_point_with_extents(Vector3(0, 5, 0), Vector3(1, 1, 1)), Vector3.INF
	)


func test_get_simple_path_failed():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources([plane_mesh])

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)
	var path = navmesh.get_simple_path(
		Vector3(-1000, -1000, -1000), Vector3(-999, -999, -999), true
	)
	var expected_path = []
	assert_almost_eq_v3arr(path, expected_path)


func test_get_simple_path_succeeded():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources([plane_mesh])

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)
	var path = navmesh.get_simple_path(Vector3(-10, 0, -10), Vector3(10, 0, 10), true)
	var expected_path = [Vector3(-4.1, 0.2, -4.1), Vector3(4, 0.2, 4)]
	assert_almost_eq_v3arr(path, expected_path)


func test_get_simple_path_nonsimplified_for_moderate_geometry_succeeded():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources_with_transforms(
		[plane_mesh, plane_mesh, plane_mesh],
		[
			Transform(Basis(), Vector3(0, 0, 0)),
			Transform(Basis(), Vector3(5, 0, 0)),
			Transform(Basis(), Vector3(5, 0, 5))
		]
	)

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)
	var path = navmesh.get_simple_path(Vector3(-10, 0, 10), Vector3(15, 0, 15), false)
	var expected_path = [
		Vector3(-4.1, 0.2, 4.3),
		Vector3(0.1, 0.2, 4.3),
		Vector3(1.041861, 0.2, 4.802326),
		Vector3(9.1, 0.2, 9.1)
	]
	assert_almost_eq_v3arr(path, expected_path)


func test_get_simple_path_for_moderate_geometry_succeeded():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources_with_transforms(
		[plane_mesh, plane_mesh, plane_mesh],
		[
			Transform(Basis(), Vector3(0, 0, 0)),
			Transform(Basis(), Vector3(5, 0, 0)),
			Transform(Basis(), Vector3(5, 0, 5))
		]
	)

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)
	var path = navmesh.get_simple_path(Vector3(-10, 0, 10), Vector3(15, 0, 15), true)
	var expected_path = [Vector3(-4.1, 0.2, 4.3), Vector3(0.1, 0.2, 4.3), Vector3(9.1, 0.2, 9.1)]
	assert_almost_eq_v3arr(path, expected_path)
