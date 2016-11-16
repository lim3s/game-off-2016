
extends Node2D

# member variables
var count = 0

var damage_boost = preload("res://scenes/abilities/damage_boost.tscn")
var height_boost = preload("res://scenes/abilities/height_boost.tscn")

func _ready():
	get_node("Label").set_text(str(count))

func add_combo(amount):
	count += amount
	get_node("Label").set_text(str(count))

func reset_combo():
	count = 0
	get_node("Label").set_text(str(count))

func consume_combo():
	var ability = null
	if (count == 1):
		# Single target damage
		ability = damage_boost.instance()
		
	elif (count == 2):
		# jump height
		ability = height_boost.instance()
		
	elif (count == 3):
		# aoe damage
		pass
	
	if (ability != null):
		add_child(ability)