extends Node2D
@onready var par1 = $CPUParticles2D
@onready var par2 = $CPUParticles2D2
@onready var par3 = $CPUParticles2D3
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		par1.emitting = true
		timer.start(0.1)
		


func _on_timer_timeout():
	par2.emitting = true
	par3.emitting = true
