extends Node2D

@onready var tree = preload("res://source.tscn")
@export var range_x:Vector2
@export var range_y:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func grow():
	var ins = tree.instantiate()
	add_child(ins)
	var x = randf_range(range_x.x,range_x.y)
	var y = randf_range(range_y.x,range_y.y)
	ins.position.x = x
	ins.position.y = y





func _on_timer_timeout():
	grow() # Replace with function body.
