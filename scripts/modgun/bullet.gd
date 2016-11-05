
# bullet script
extends Sprite
# member variables
var bullet_name

var damage
var rate_of_fire
var accuracy
var speed

func fire():
	print("Fired bullet - " + str(damage) + " damage")
	pass