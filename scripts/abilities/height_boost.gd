
extends "res://scripts/abilities/ability.gd"

var boost_speed = 1800

func fire_ability():
	# get the root player and give them a jump boost
	get_node("../..").velocity.y = -boost_speed
	queue_free()