
extends "res://scripts/abilities/ability.gd"

var boost_amount = 10

func fire_ability():
	get_node("../..").bonus_damage = boost_amount
	queue_free()


