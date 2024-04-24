extends Node


var slime_scene = preload("res://slime.tscn")


func generate_slime() -> Slime:
	var slime = slime_scene.instantiate()
	return slime
