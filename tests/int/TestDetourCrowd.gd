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
	var agent_1_start_pos = Vector3(0, 99999, 0)
	var agent_1 = crowd.create_agent(agent_1_start_pos, agent_1_config)
	assert_true(agent_1 != null)
	assert_eq(agent_1.state, agent_1.STATE_INVALID)
	var agent_1_actual_pos = agent_1.position
	assert_almost_eq_v3(agent_1_actual_pos, Vector3(0, 99999, 0))


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
	var agent_1 = crowd.create_agent(Vector3(-5, 10, -5), agent_1_config)
	assert_true(agent_1 != null)
	assert_eq(agent_1.state, agent_1.STATE_WALKING)
	assert_almost_eq_v3(agent_1.position, Vector3(-4.1, 0.2, -4.1))
	assert_true(agent_1.set_target(Vector3(5, 0, 5)))
	assert_almost_eq_v3(agent_1.get_target(), Vector3(4.0, 0.2, 4.0))
	crowd.update(999.0)
	assert_almost_eq_v3(agent_1.position, Vector3(4.0, 0.2, 4.0))


func test_agent_movement_interrupted():
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
	var agent_1 = crowd.create_agent(Vector3(-5, 10, -5), agent_1_config)
	assert_almost_eq_v3(agent_1.position, Vector3(-4.1, 0.2, -4.1))
	assert_true(agent_1.set_target(Vector3(5, 0, 5)))
	assert_almost_eq_v3(agent_1.get_target(), Vector3(4.0, 0.2, 4.0))
	assert_true(agent_1.set_target(Vector3.INF))
	crowd.update(999.0)
	assert_almost_eq_v3(agent_1.position, Vector3(-4.1, 0.2, -4.1))


func test_agent_acceleration_and_speed():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(100, 100)
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
	var agent_1_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	agent_1_config.max_acceleration = 1.0
	agent_1_config.max_speed = 3.0
	var agent_1 = crowd.create_agent(Vector3(0, 0, 0), agent_1_config)
	assert_eq(agent_1.state, agent_1.STATE_WALKING)
	assert_almost_eq_v3(agent_1.position, Vector3(0.0, 0.2, 0.0))
	assert_true(agent_1.set_target(Vector3(20, 0, 0)))
	assert_almost_eq_v3(agent_1.get_target(), Vector3(20.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(1.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(3.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(6.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(9.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(12.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(15.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(18.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(21.0, 0.2, 0.0))  # overshoot
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(23.0, 0.2, 0.0))  # slowing down
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(24.0, 0.2, 0.0))  # slowing down
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(24.0, 0.2, 0.0))  # going back
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(23.0, 0.2, 0.0))  # going back
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(21.0, 0.2, 0.0))  # going back
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(18.536127, 0.2, -0.006896))  # overshoot again


func test_agent_acceleration_and_speed_with_dense_updates():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(100, 100)
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
	var agent_1_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	agent_1_config.max_acceleration = 1.0
	agent_1_config.max_speed = 3.0
	var agent_1 = crowd.create_agent(Vector3(0, 0, 0), agent_1_config)
	assert_eq(agent_1.state, agent_1.STATE_WALKING)
	assert_almost_eq_v3(agent_1.position, Vector3(0.0, 0.2, 0.0))
	assert_true(agent_1.set_target(Vector3(20, 0, 0)))
	assert_almost_eq_v3(agent_1.get_target(), Vector3(20.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(1.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(3.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(6.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(9.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(12.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(15.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(18.0, 0.2, 0.0))
	for _i in range(60):
		crowd.update(0.016666666666666666)
	assert_almost_eq_v3(agent_1.position, Vector3(20.737211, 0.2, 0.0))  # overshoot
	for _i in range(60):
		crowd.update(0.016666666666666666)
	assert_almost_eq_v3(agent_1.position, Vector3(22.512211, 0.2, 0.0))  # slowing down
	for _i in range(60 * 11):  # ~11s required to stabilize
		crowd.update(0.016666666666666666)
	assert_almost_eq_v3(agent_1.position, Vector3(20.0, 0.2, 0.0))


func test_agent_speed_increase():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(100, 100)
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
	var agent_1_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	agent_1_config.max_acceleration = 1.0
	agent_1_config.max_speed = 3.0
	var agent_1 = crowd.create_agent(Vector3(0, 0, 0), agent_1_config)
	assert_eq(agent_1.state, agent_1.STATE_WALKING)
	assert_almost_eq_v3(agent_1.position, Vector3(0.0, 0.2, 0.0))
	assert_true(agent_1.set_target(Vector3(20, 0, 0)))
	assert_almost_eq(agent_1.velocity.length(), 0.0, EPSILON)
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(1.0, 0.2, 0.0))
	assert_almost_eq(agent_1.velocity.length(), 1.0, EPSILON)
	crowd.update(0.5)
	assert_almost_eq_v3(agent_1.position, Vector3(1.75, 0.2, 0.0))
	assert_almost_eq(agent_1.velocity.length(), 1.5, EPSILON)


func test_agent_avoiding_agent():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(100, 100)
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
	var agent_1_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	agent_1_config.radius = 0.6
	agent_1_config.max_acceleration = 0.6
	agent_1_config.max_speed = 1.2
	agent_1_config.collision_query_range = agent_1_config.radius * 8
	agent_1_config.separation_weight = 0
	var agent_2_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	agent_2_config.radius = 0.6
	agent_2_config.max_acceleration = 0.6
	agent_2_config.max_speed = 1.2
	agent_2_config.collision_query_range = agent_2_config.radius * 8
	agent_2_config.separation_weight = 0
	var agent_1 = crowd.create_agent(Vector3(0, 0, 0), agent_1_config)
	var agent_2 = crowd.create_agent(Vector3(10, 0, 0), agent_2_config)
	assert_eq(agent_1.state, agent_1.STATE_WALKING)
	assert_eq(agent_2.state, agent_1.STATE_WALKING)
	assert_almost_eq_v3(agent_1.position, Vector3(0.0, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(10.0, 0.2, 0.0))
	assert_true(agent_1.set_target(Vector3(10, 0, 0)))
	assert_true(agent_2.set_target(Vector3(0, 0, 0)))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(0.6, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(9.4, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(1.8, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(8.2, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(3.0, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(7.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(4.07, 0.2, -0.33))
	assert_almost_eq_v3(agent_2.position, Vector3(5.92, 0.2, 0.33))
	crowd.update(0.3)
	assert_almost_eq_v3(agent_1.position, Vector3(4.38, 0.2, -0.44))
	assert_almost_eq_v3(agent_2.position, Vector3(5.61, 0.2, 0.44))
	crowd.update(0.55)
	assert_almost_eq_v3(agent_1.position, Vector3(4.97, 0.2, -0.62))
	assert_almost_eq_v3(agent_2.position, Vector3(5.02, 0.2, 0.62))


func test_agent_not_avoiding_disabled_agent():
	# input:
	var input_geometry = AdvancedNavigationServer3D.create_empty_input_geometry()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(100, 100)
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
	var agent_1_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	agent_1_config.radius = 0.6
	agent_1_config.max_acceleration = 0.6
	agent_1_config.max_speed = 1.2
	agent_1_config.collision_query_range = agent_1_config.radius * 8
	agent_1_config.separation_weight = 0
	var agent_2_config = AdvancedNavigationServer3D.create_empty_detour_crowd_agent_config()
	agent_2_config.radius = 0.6
	agent_2_config.max_acceleration = 0.6
	agent_2_config.max_speed = 1.2
	agent_2_config.collision_query_range = agent_2_config.radius * 8
	agent_2_config.separation_weight = 0
	var agent_1 = crowd.create_agent(Vector3(0, 0, 0), agent_1_config)
	var agent_2 = crowd.create_agent(Vector3(5, 0, 0), agent_2_config)
	assert_eq(agent_1.state, agent_1.STATE_WALKING)
	assert_eq(agent_2.state, agent_1.STATE_WALKING)
	assert_almost_eq_v3(agent_1.position, Vector3(0.0, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(5.0, 0.2, 0.0))
	assert_true(agent_1.set_target(Vector3(10, 0, 0)))
	assert_true(agent_2.set_target(Vector3(0, 0, 0)))
	agent_2.disable()
	assert_eq(agent_2.state, agent_1.STATE_DISABLED)
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(0.6, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(5.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(1.8, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(5.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(3.0, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(5.0, 0.2, 0.0))
	crowd.update(1.0)
	assert_almost_eq_v3(agent_1.position, Vector3(4.2, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(5.0, 0.2, 0.0))
	crowd.update(0.3)
	assert_almost_eq_v3(agent_1.position, Vector3(4.56, 0.2, 0.0))
	assert_almost_eq_v3(agent_2.position, Vector3(5.0, 0.2, 0.0))
	crowd.update(0.55)
	assert_almost_eq_v3(agent_1.position, Vector3(5.22, 0.2, 0.0))
