
# damage module
extends "res:/scripts/modgun/module.gd"

# override modification function
func modify_bullet(bullet):
	bullet.damage += 10
	bullet.set_scale(bullet.get_scale() * 1.2)