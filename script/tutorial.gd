extends Node2D


var cur = 1
@onready var tutorial_1 = $Tutorial1
@onready var tutorial_2 = $Tutorial2
@onready var tutorial_3 = $Tutorial3


func _on_next_button_pressed():
	if cur == 1:
		tutorial_1.hide()
		tutorial_2.show()
	elif cur == 2:
		tutorial_2.hide()
		tutorial_3.show()
	else:
		SceneTrans.transition("res://main.tscn")
	
	cur += 1


func _on_skip_button_pressed():
	SceneTrans.transition("res://main.tscn")
