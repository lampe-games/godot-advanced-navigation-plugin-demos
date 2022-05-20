extends "res://addons/gut/test.gd"

const EPSILON3 = Vector3(0.01, 0.01, 0.01)


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
	assert_eq(navmesh.get_closest_point(Vector3.ZERO), Vector3.INF)


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
	assert_almost_eq(navmesh.get_closest_point(Vector3(0, 5, 0)), Vector3(0, 0.2, 0), EPSILON3)
	assert_almost_eq(
		navmesh.get_closest_point(Vector3(-10, 0, -10)), Vector3(-4.1, 0.2, -4.1), EPSILON3
	)
	assert_almost_eq(navmesh.get_closest_point(Vector3(10, 0, 10)), Vector3(4, 0.2, 4), EPSILON3)
