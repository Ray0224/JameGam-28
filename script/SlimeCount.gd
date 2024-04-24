extends Label


var count := 0


func _ready():
	count = get_tree().get_nodes_in_group('slime').size()
	text = str(count)
	EventBus.slime_added.connect(increment_count)
	EventBus.slime_freed.connect(decrease_count)
	

func increment_count():
	count += 1
	text = str(count)
	
	if count == 70:
		EventBus.slime_added.disconnect(increment_count)
		EventBus.slime_freed.disconnect(decrease_count)
		get_tree().call_deferred("set_pause", true)
		EventBus.game_ended.emit()
	elif count >= 60:
		$AnimationPlayer.play("alarm")
		
		
func decrease_count():
	count -= 1
	text = str(count)
	
	if count < 60:
		$AnimationPlayer.play("RESET")

	if count == 0:
		EventBus.slime_added.disconnect(increment_count)
		EventBus.slime_freed.disconnect(decrease_count)
		get_tree().call_deferred("set_pause", true)
		EventBus.game_ended.emit()
