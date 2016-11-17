
extends KinematicBody2D

# static platform that can be killed

export var health = 10

# called when hit by a slam
func slam_kill(damage):
	health -= damage
	if (health <= 0):
		queue_free()