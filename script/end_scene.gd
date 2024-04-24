extends CanvasLayer


func _ready():
	EventBus.game_ended.connect(start_end)


func start_end():
	show()
	$AnimationPlayer.play("failed")


func _on_retry_pressed():
	SceneTrans.transition("res://main.tscn")
#	get_tree().reload_current_scene();
