extends Node2D


var velocity: Vector2
var cool_down := false
var close := false

@export var move_speed := 250.0

@onready var hit_area = $Node/TargetBody/HitArea as Area2D
@onready var target_body = $Node/TargetBody as StaticBody2D
@onready var rotate_pivot = $RotatePivot
@onready var mask = $RotatePivot/MaskSprite
@onready var shoot_pivot = $RotatePivot/ShootPivot
@onready var laser = $RotatePivot/MaskSprite/Laser
@onready var animation_player = $AnimationPlayer
@onready var shoot_button = $ShootButton


func _ready():
	velocity = Vector2.from_angle(PI / 2 * randi_range(0, 3) + PI / 4) * move_speed


func _process(delta):
	var collision: KinematicCollision2D = target_body.move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())

	rotate_pivot.look_at(target_body.global_position)


func _on_shoot_button_pressed():
	cool_down = true
	set_process(false)
	shoot_button.disabled = true
	
	mask.texture.width = round((target_body.global_position - shoot_pivot.global_position).length())
	mask.global_position = (target_body.global_position + shoot_pivot.global_position) / 2
	
	laser.show()
	animation_player.play("shoot")
	
	var targeted_slimes = hit_area.get_overlapping_bodies() as Array[Slime]
	for slime in targeted_slimes:
		slime.die()
	
	EventBus.box_energy_charged.emit(targeted_slimes.size())

	await animation_player.animation_finished
	laser.hide()
	
	await get_tree().create_timer(0.5).timeout
	set_process(true)
	cool_down = false
	if !close:
		shoot_button.disabled = false


func enable():
	close = false
	if !cool_down:
		shoot_button.disabled = false
	
	
func disable():
	close = true
	shoot_button.disabled = true
