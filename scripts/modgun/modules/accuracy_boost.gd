
# damage module
extends "res:/scripts/modgun/module.gd"

# override modification function
func modify_bullet(bullet):
	bullet.accuracy += 0.05
	bullet.set_scale(bullet.get_scale() * 0.8)