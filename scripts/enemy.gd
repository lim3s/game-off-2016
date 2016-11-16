
extends KinematicBody2D
# basic enemy that moves left and right

var movement_speed = 200

var velocity = Vector2()

export var health = 10

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# move enemy
	velocity.x = movement_speed
	# slight gravity downwards
	velocity.y = 100
	
	var motion = velocity * delta
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		# check if enemy has hit a wall
		if (n == Vector2(-1, 0) || n == Vector2(1, 0)):
			# flip movement
			movement_speed *= -1
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)

# called when hit by a slam
func slam_kill(damage):
	health -= damage
	if (health <= 0):
		queue_free()
