extends Node


@onready var character: Slime = owner


func get_velocity():
	var source_list = get_tree().get_nodes_in_group("source")
	source_list.sort_custom(sort_source_distance)
	
	if source_list.is_empty():
		var move_direction = randf_range(0, 2 * PI)
		character.velocity = Vector2.from_angle(move_direction) * owner.move_speed
	else:
		character.velocity = (source_list[0].global_position - character.global_position).normalized() * owner.move_speed


func sort_source_distance(s1: Source, s2: Source) -> bool:
	var d1 = owner.global_position.distance_squared_to(s1.global_position)
	var d2 = owner.global_position.distance_squared_to(s2.global_position)
	
	return d1 < d2
