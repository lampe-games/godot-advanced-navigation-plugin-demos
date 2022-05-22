extends "res://tests/int/Utils.gd"


func test_server_is_present():
	assert_true(AdvancedNavigationServer3D is Node)


func test_emptry_detour_crowd_created():
	var crowd = AdvancedNavigationServer3D.create_empty_detour_crowd()
	assert_true(crowd != null)


func test_detour_crowd_initialized():
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
	var crowd_config = AdvancedNavigationServer3D.create_empty_detour_crowd_config()
	assert_true(crowd_config != null)

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	assert_true(navmesh != null)
	assert_true(navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config))

	# crowd:
	var crowd = AdvancedNavigationServer3D.create_empty_detour_crowd()
	assert_true(crowd != null)
	assert_true(crowd.initialize(crowd_config, navmesh))
