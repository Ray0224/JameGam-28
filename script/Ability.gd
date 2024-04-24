class_name Ability
extends Node2D


@onready var animation_player = $AnimationPlayer as AnimationPlayer


func cast_on(slime: Slime):
	slime.add_child(self)
	animation_player.play("cast")
	await animation_player.animation_finished
	queue_free()


func get_cast_time() -> float:
	return animation_player.get_animation('cast').length
	
