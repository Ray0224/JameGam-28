class_name Source
extends Area2D

@onready var aniPlayer = $Sprite2D/AnimationPlayer


func _ready():
	var list = aniPlayer.get_animation_list()
	var number_Play = randi_range(1,list.size()-1)	
	aniPlayer.play(list[number_Play])

