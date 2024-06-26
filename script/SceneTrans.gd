extends CanvasLayer


@onready var animation_player = $AnimationPlayer


func transition(target: String):
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target)
	
	animation_player.play_backwards("fade_in")
	get_tree().paused = false
