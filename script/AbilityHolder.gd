class_name AbilityHolder
extends Node2D


var num_ability := 0

@export var max_ability := 5

@onready var path_follow = $AbilityPlacePath/AbilityPathFollow as PathFollow2D
@onready var abilities = $Abilities as Node2D


func add_ability(new_ability: Ability):
	if num_ability >= max_ability:
		return
	
	path_follow.progress_ratio = 1.0 / (max_ability - 1) * num_ability
	abilities.add_child(new_ability)
	new_ability.position = path_follow.position
	num_ability += 1
	
	
func place_abilities():
	for i in num_ability:
		path_follow.progress_ratio = 1.0 / (max_ability - 1) * i
		var ability: Ability = abilities.get_child(i)
		ability.position = path_follow.position
		
	
func _ready():
	num_ability = abilities.get_child_count()
	for i in range(3):
		var ability = load("res://ability.tscn").instantiate()
		add_ability(ability)


func _on_ability_launched(_ability: Ability):
	call_deferred("place_abilities")
	num_ability -= 1
