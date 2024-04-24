extends Node2D


signal used()
signal finished()

var useable := false
var max_charge_level := 10
var ability_name = ['knife', 'tornado', 'poison', 'fire', 'lightning']

@onready var final = $final
@onready var animation_player = $AnimationPlayer
@onready var progress_bar = $ProgressBar


func _ready():
	EventBus.box_energy_charged.connect(add_energy)


func add_energy(value: int):
	if progress_bar.value < progress_bar.max_value:
		progress_bar.value += value


func _on_area_2d_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_pressed("LeftClick"):
		if useable:
			used.emit()
			progress_bar.value = 0
			useable = false
			var rand_idx: int = randi_range(0, 4)

			animation_player.play("use_lever")
			await animation_player.animation_finished

			animation_player.play("go")
			BgmManager.play_audio("warning")
			get_tree().call_group("slime", "panic")
			await get_tree().create_timer(2).timeout
			animation_player.stop()

			final.frame = rand_idx
			final.show()
			await get_tree().create_timer(1).timeout
			await AbilityGenerator.launch(ability_name[rand_idx])
			
			final.hide()
			BgmManager.stop_audio("warning")
			get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "slime", "relax")
			finished.emit()


func _on_progress_bar_value_changed(value):
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", value, 0.1)

	if value == progress_bar.max_value:
		await tween.finished
		useable = true
