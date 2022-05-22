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
