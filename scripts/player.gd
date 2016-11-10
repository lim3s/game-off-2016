
extends KinematicBody2D

var movement_speed = 500
var gravity_normal = 50
var gravity_slam = 120
var max_fall_speed = 2000

var jump_speed = 1200 # normal jump speed
var slam_first_hop_speed = 1000 # hop speed, higher gravity applied
var slam_combo_hop_speed = 500 # hop after hitting enemy, normal gravity
var can_jump = false
var can_slam = false

var jumping = false
var slamming = false

var jump_key_free = true

var velocity = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# player movement
	
	if (!slamming):
		velocity.y += gravity_normal
	else:
		velocity.y += gravity_slam
	
	if (velocity.y > max_fall_speed):
		velocity.y = max_fall_speed
	
	if (Input.is_action_pressed("player_left") && !Input.is_action_pressed("player_right")):
		velocity.x = - movement_speed
	elif (Input.is_action_pressed("player_right") && !Input.is_action_pressed("player_left")):
		velocity.x = movement_speed
	else:
		velocity.x = 0
	
	if (Input.is_action_pressed("player_jump") && jump_key_free):
		jump_key_free = false
		if (can_jump):
			# jump
			can_jump = false
			can_slam = true
			jumping = true
			velocity.y = -jump_speed
		elif (can_slam):
			# body slam
			can_slam = false
			slamming = true
			jumping = false
			velocity.y = -slam_first_hop_speed
	elif (!Input.is_action_pressed("player_jump") && !jump_key_free):
		jump_key_free = true
	
	var motion = velocity * delta
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		# check if can jump
		if (n == Vector2(0, -1) && !Input.is_action_pressed("player_jump")):
			can_jump = true
			can_slam = false
			slamming = false
			jumping = false
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
	else:
		can_jump = false