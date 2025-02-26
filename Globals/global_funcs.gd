extends Node

func vector_to_angle(vector: Vector2):
	var angle =  rad_to_deg(acos(Vector2(0, -1).dot(vector)))
	
	if vector.x < 0:
		angle = 360 - angle
	
	return angle


func find_closest_vector(from: Vector2, vectors: Array[Vector2]):
	var closest_vect: Vector2
	var closest_dist: float
	
	for vector in vectors:
		if from.distance_to(vector) < closest_dist or not closest_vect:
			closest_vect = vector
			closest_dist = from.distance_to(closest_vect)
	
	return closest_vect


func find_closest_object(from: Vector2, objects: Array):
	var closest_obj
	var closest_dist: float
	
	for object in objects:
		if object is Node3D and (from.distance_to(object.global_position) < closest_dist or not closest_obj):
			closest_obj = object
			closest_dist = from.distance_to(closest_obj.global_position)
	
	return closest_obj
