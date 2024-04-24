extends CPUParticles2D

var fire1 = preload("res://RayTest/particles/fire1.png")
var fire2 = preload("res://RayTest/particles/fire2.png")
var fire3 = preload("res://RayTest/particles/fire3.png")
@onready var fires = [fire1,fire2,fire3]
@onready var particles =  $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var number = randi_range(0,fires.size()-1)
	particles.texture = fires[number]
