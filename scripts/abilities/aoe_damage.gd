
extends "res://scripts/abilities/ability.gd"

var aoe_damage = 10

func fire_ability():
	for body in get_node("Area2d").get_overlapping_bodies():
		if (body.is_in_group("enemy")):
			body.slam_kill(aoe_damage)
	
	queue_free()


