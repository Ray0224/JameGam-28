class_name Slime
extends CharacterBody2D


var move_strategy: Node
#var is_hungry := false
var random_move_wait_time: float
var is_dying := false
var type := "normal"
var type_shader = {"knife": preload("res://shader/iron_slime.tres"),
					"fire": preload("res://shader/fire_slime.tres"),
					"poison": preload("res://shader/poison_slime.tres"),
					"tornado": preload("res://shader/tornado_slime.tres"),
					"lightning": preload("res://shader/lightning_slime.tres")} 

var mutation_chance = 0.1

@export var move_speed: float = 1000
#@export var hungry_move_wait_time := 1.0

@onready var random_move = $Movement/RandomMove
@onready var hungry_move = $Movement/HungryMove
@onready var move_timer = $MoveTimer
@onready var split_timer = $SplitTimer
#@onready var hungry_timer = $HungryTimer
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var eat_area = $EatArea
@onready var center_marker = $CenterMarker
@onready var neighbor_detect_area = $CenterMarker/NeighborDetectArea
@onready var death_sprite = $DeathSprite


func _ready():
	move_strategy = random_move
	random_move_wait_time = randf_range(3, 6)
	move_timer.start(random_move_wait_time)
	split_timer.start(randf_range(5, 10))
#	EventBus.slime_added.emit()
#	hungry_timer.start()


func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		
	velocity = lerp(velocity, Vector2.ZERO, 0.1)
	if velocity.x > 0 and sprite_2d.flip_h:
		sprite_2d.flip_h = false
	elif velocity.x < 0 and not sprite_2d.flip_h:
		sprite_2d.flip_h = true
	
#	if is_hungry and eat_area.has_overlapping_areas():
#		var source_list = eat_area.get_overlapping_areas()
#		var source = source_list[0]
#		eat(source)
#

func split():
	var empty_points: Array[Vector2] = get_empty_points()
	if empty_points.size() < 2:
		return
	
	empty_points.shuffle()
	
	move_timer.stop()
	split_timer.stop()
	
	var slime1: Slime = SlimeGenerator.generate_slime()
	var slime2: Slime = SlimeGenerator.generate_slime()
	
	slime1.global_position = empty_points[0]
	slime2.global_position = empty_points[1]
	
	animation_player.play("split")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	if animation_player.current_animation != "split":
		return
		
	get_parent().add_child(slime1)
	get_parent().add_child(slime2)
	
	slime1.type = type
	slime2.type = type
	
	if type != 'normal':
		slime1.mutate(type)
		slime2.mutate(type)
	
	slime1.change_direction()
	slime2.change_direction()
	
	free_slime()


func panic():
	if is_dying:
		return
	move_timer.stop()
	split_timer.stop()
	
	animation_player.play("RESET")
	animation_player.play("shake")


func relax():
	if is_dying:
		return
	move_timer.start()
	split_timer.start()
	animation_player.play("idle")
	
#func eat(source: Source):
#	move_timer.stop()
#	source.queue_free()
#
#	animation_player.stop()
#	animation_player.play("eat")
#	await animation_player.animation_finished
#
#	is_hungry = false
#	move_strategy = random_move
#	move_timer.start(random_move_wait_time)
#	split_timer.start()
#	hungry_timer.start()


func die(die_type: String = "normal"):
	if is_dying:
		return
	
	move_timer.stop()
	split_timer.stop()
	
	if die_type == "normal":
		is_dying = true
		animation_player.play("death")
		await animation_player.animation_finished
		free_slime()
		return
		
	if type == die_type:
		return
		
	var random = randf_range(0, 1)
	if random <= mutation_chance:
		mutate(die_type)
		return
	
	is_dying = true
	if die_type == 'fire' or die_type == 'lightning':
		death_sprite.show()
		sprite_2d.hide()
		animation_player.play("death_fire_lightning")
	elif die_type == 'poison':
		death_sprite.show()
		sprite_2d.hide()
		animation_player.play("death_poison")
	else:
		animation_player.play("death")
		
	await animation_player.animation_finished
	free_slime()


func mutate(mutate_type):
	type = mutate_type
	sprite_2d.material = ShaderMaterial.new()
	sprite_2d.material.shader = type_shader[type]
	

func change_direction():
	move_strategy.get_velocity()
	animation_player.play("walk")
	animation_player.queue("idle")


func get_empty_points() -> Array[Vector2]:
	var empty_points = [] as Array[Vector2]
	for i in 5:
		center_marker.rotate(PI / 3)
		if !neighbor_detect_area.has_overlapping_bodies():
			empty_points.append(neighbor_detect_area.global_position - sprite_2d.offset)
	
	return empty_points


func free_slime():
#	EventBus.slime_freed.emit()
	queue_free()
#func get_hungry():
#	is_hungry = true
#	split_timer.stop()
#	move_timer.stop()
#	move_strategy = hungry_move
#	move_timer.start(hungry_move_wait_time)


func _on_tree_entered():
	EventBus.slime_added.emit()
	
	
func _on_tree_exited():
	EventBus.slime_freed.emit()
