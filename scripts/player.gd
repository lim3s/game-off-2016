
extends KinematicBody2D

const movement_speed = 500
const gravity_normal = 50
const gravity_slam = 110
const max_fall_speed = 2000

const jump_speed = 1200 # normal jump speed
const slam_first_hop_speed = 1000 # hop speed, higher gravity applied
const slam_combo_hop_speed = 800 # hop after hitting enemy, normal gravity

var can_jump = false
var can_slam = false

var slam_damage = 10
var bonus_damage = 0

var health = 3
var invul = false
var hitstunned = false
var damage_knockback = 800

var jumping = false
var slamming = false

var jump_key_free = true
var fire_combo = false

var velocity = Vector2()

# node references
onready var slam_hitbox = get_node("SlamHitbox")
onready var hurtbox = get_node("Hurtbox")
onready var combo = get_node("Combo")
onready var invul_timer = get_node("InvulTimer")
onready var hitstun_timer = get_node("HitstunTimer")
onready var jump_hold_timer = get_node("JumpHoldTimer")

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	# player movement
	
	if (!slamming):
		velocity.y += gravity_normal
	else:
		velocity.y += gravity_slam
	
	if (velocity.y > max_fall_speed):
		velocity.y = max_fall_speed
	
	if (!hitstunned):
		if (Input.is_action_pressed("player_left") && !Input.is_action_pressed("player_right")):
			velocity.x = - movement_speed
		elif (Input.is_action_pressed("player_right") && !Input.is_action_pressed("player_left")):
			velocity.x = movement_speed
		else:
			velocity.x = 0
	
	# check collision with slam hitbox
	if (slamming):
		for body in slam_hitbox.get_overlapping_bodies():
			if (body.is_in_group("enemy")):
				body.slam_kill(slam_damage + bonus_damage)
				if (bonus_damage > 0):
					bonus_damage = 0
				
				velocity.y = -slam_combo_hop_speed
				slamming = false
				can_slam = true
				
				if (fire_combo):
					fire_combo = false
					combo.consume_combo()
					combo.reset_combo()
				else:
					combo.add_combo(1)
	else:
		for body in hurtbox.get_overlapping_bodies():
			if (body.is_in_group("enemy")):
				# take damage and knockback
				# set invul timer
				health -= 1
	
	# move player (should be done last)
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
			
			combo.reset_combo()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
	else:
		can_jump = false

func _input(event):
	if (event.is_action_pressed("player_jump") && !event.is_echo()):
		if (can_jump):
			jump()
			jump_key_free = false
		elif (can_slam):
			jump_hold_timer.start()
			slam()
	if (event.is_action_released("player_jump") && !event.is_echo()):
		if (slamming):
			jump_hold_timer.stop()

func jump():
	# jump
	can_jump = false
	can_slam = true
	jumping = true
	velocity.y = -jump_speed

func slam():
	# body slam
	can_slam = false
	slamming = true
	jumping = false
	velocity.y = -slam_first_hop_speed

func invul_timer_ended():
	invul = false

func hitstun_timer_ended():
	hitstunned = false

func jump_timer_ended():
	print("Combo firing")
	fire_combo = true