
extends Area2D

export var next_level_path = ""

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func body_enter( body ):
	if (body.is_in_group("player")):
		# go to the next level
		pass
