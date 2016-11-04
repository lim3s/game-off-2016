
# damage module
extends "res:/scripts/modgun/module.gd"

# override modification function
func modify_bullet(bullet):
	bullet.rate_of_fire -= 0.1