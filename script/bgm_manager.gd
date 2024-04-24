extends Node


@onready var bgm = $BGM as AudioStreamPlayer2D
@onready var warning = $Warning as AudioStreamPlayer2D


func _ready():
	bgm.play()


func play_audio(target: String):
	
#	if target == 'bgm':
#		current_audio = bgm
#		current_audio.stream_paused = false
	if target == 'warning':
		warning.play()
	bgm.volume_db = -20


func stop_audio(target: String):
	if target == 'warning':
		warning.stop()
	bgm.volume_db = 0
