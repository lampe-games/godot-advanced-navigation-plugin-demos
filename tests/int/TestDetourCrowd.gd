extends "res://tests/int/Utils.gd"


func test_server_is_present():
	assert_true(AdvancedNavigationServer3D is Node)


func test_empty_detour_crowd_created():
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
	var crowd = navmesh.create_crowd(crowd_config)
	assert_true(crowd != null)


func test_add_agent_on_mesh_succeeded():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources([plane_mesh])

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()
	var crowd_config = AdvancedNavigationServer3D.create_empty_detour_crowd_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)

	# crowd:
	var crowd = navmesh.create_crowd(crowd_config)
	assert(crowd)
	var agent_1_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	assert_true(agent_1_config != null)
	var agent_1_start_pos = navmesh.get_closest_point(Vector3(0, 0, 0))
	var agent_1 = crowd.create_agent(agent_1_start_pos, agent_1_config)
	assert_true(agent_1 != null)
	assert_eq(agent_1.state, agent_1.STATE_WALKING)
	var agent_1_actual_pos = agent_1.position
	assert_almost_eq_v3(agent_1_actual_pos, Vector3(0, 0.2, 0))


func test_add_agent_off_mesh_succeeded():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources([plane_mesh])

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()
	var crowd_config = AdvancedNavigationServer3D.create_empty_detour_crowd_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)

	# crowd:
	var crowd = navmesh.create_crowd(crowd_config)
	assert(crowd)
	var agent_1_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	assert_true(agent_1_config != null)
	var agent_1_start_pos = Vector3(0, 5, 0)
	var agent_1 = crowd.create_agent(agent_1_start_pos, agent_1_config)
	assert_true(agent_1 != null)
	assert_eq(agent_1.state, agent_1.STATE_INVALID)
	var agent_1_actual_pos = agent_1.position
	assert_almost_eq_v3(agent_1_actual_pos, Vector3(0, 5, 0))


func test_small_step_for_agent_but_big_setp_for_mankind():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(10, 10)
	input_geometry.add_resources([plane_mesh])

	# config:
	var recast_config = AdvancedNavigationServer3D.create_empty_recast_polygon_mesh_config()
	var detour_config = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh_config()
	var crowd_config = AdvancedNavigationServer3D.create_empty_detour_crowd_config()

	# navmesh:
	var navmesh = AdvancedNavigationServer3D.create_empty_detour_navigation_mesh()
	navmesh.build_from_input_geometry(input_geometry, recast_config, detour_config)

	# crowd:
	var crowd = navmesh.create_crowd(crowd_config)
	assert(crowd)
	var agent_1_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	assert_true(agent_1_config != null)
	var agent_1_start_pos = navmesh.get_closest_point(Vector3(-5, 0, -5))
	var agent_1 = crowd.create_agent(agent_1_start_pos, agent_1_config)  # consider auto-alignment so that we don't need to "get_closest_point"
	assert_true(agent_1 != null)
	assert_eq(agent_1.state, agent_1.STATE_WALKING)
	var agent_1_actual_pos = agent_1.position
	assert_almost_eq_v3(agent_1_actual_pos, Vector3(-4.1, 0.2, -4.1))
	assert_true(agent_1.set_target(Vector3(5, 0, 5)))
	assert_almost_eq_v3(agent_1.get_target(), Vector3(4.0, 0.2, 4.0))
