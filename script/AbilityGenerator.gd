extends Node


@onready var lightning = preload("res://particle/lightning.tscn")
@onready var fire = preload("res://particle/fireParticle.tscn")
@onready var knife = preload("res://particle/knife.tscn")
@onready var poison = preload("res://particle/Poison.tscn")
@onready var tornado = preload("res://particle/tornado.tscn")


func launch(ability_name: String):
	var ability_scene: PackedScene
	
	if ability_name == 'fire':
		ability_scene = fire
	elif ability_name == 'knife':
		ability_scene = knife
	elif ability_name == 'lightning':
		ability_scene = lightning
	elif ability_name == 'poison':
		ability_scene = poison
	elif ability_name == 'tornado':
		ability_scene = tornado
	
	var slime_list: Array[Node] = get_tree().get_nodes_in_group("slime")
	slime_list.shuffle()
	
	var ability: Ability
	var target_num = randi_range(ceil(slime_list.size() * 0.1), slime_list.size())
	
	for i in target_num:
		var slime: Slime = slime_list[i]
		ability = ability_scene.instantiate()
		ability.call_deferred("cast_on", slime)
	
	await ability.ready
	await ability.animation_player.animation_finished
	
	for i in target_num:
		var slime: Slime = slime_list[i]
		slime.call_deferred("die", ability_name)
