extends Node


@onready var character: Slime = owner


func get_velocity():
	var move_direction = randf_range(0, 2 * PI)
	character.velocity = Vector2.from_angle(move_direction) * owner.move_speed
