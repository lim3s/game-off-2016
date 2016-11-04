
# gun script
extends Node
# member variables
var gun_name

var modules = []
var grid_dimensions = Vector2()

var root_module # module object ref
var tail_module # module object ref

var base_bullet # bullet object ref
var modified_bullets  = [] # list of bullet object ref after modifications
var bullet_timers = [] # list of countdown timers for bullets

func _ready():
	init()
	
	set_process(true)

func _process(delta):
	for timer in bullet_timers:
		timer -= delta
		if (timer < 0):
			timer = 0

func init():
	base_bullet = load("res://scenes/bullet.tscn").instance()
	grid_dimensions = Vector2(4, 2)
	gun_name = "Pistol"
	set_bullet_stats()
	load_bullet()

func set_bullet_stats():
	base_bullet.damage = 20
	base_bullet.rate_of_fire = 0.2
	base_bullet.accuracy = 0.9
	base_bullet.speed = 800

func load_bullet():
	var new_bullet = base_bullet.duplicate()
	if (root_module != null):
		root_module.load_bullet(modified_bullets, new_bullet)

func add_module(module, pos):
	modules.append(module)
	if (pos == "root"):
		root_module = module
	elif (pos == "tail"):
		tail_module = module
	
	load_bullet()

func fire_bullet():
	for modified_bullet in modified_bullets:
		if (bullet_timers.size() <= modified_bullets.find(modified_bullet) || bullet_timers[modified_bullets.find(modified_bullet)] == 0):
			var new_bullet = modified_bullet.duplicate()
			new_bullet.fire()
			if (bullet_timers.size() <= modified_bullets.find(modified_bullet)):
				bullet_timers.append(modified_bullet.rate_of_fire)
			else:
				bullet_timers[modified_bullets.find(modified_bullet)] = modified_bullet.rate_of_fire
