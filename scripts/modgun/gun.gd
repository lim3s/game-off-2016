
# gun script
extends Node
# member variables
var gun_name

var modules = []
var grid_dimensions = Vector2()

var root_module # module object ref
var tail_module # module object ref

var base_bullet_scene = preload("res://scenes/bullet.tscn")
var base_bullet # bullet object ref
var modified_bullets  = [] # list of bullet object ref after modifications
var bullet_timers = [] # list of countdown timers for bullets

func _ready():
	init()
	
	set_process_input(true)
	set_process(true)

func _input(event):
	if (event.is_action_pressed("player_click")):
		fire_bullet()

func _process(delta):
	for timer in bullet_timers:
		timer -= delta
		if (timer < 0):
			timer = 0

func init():
	base_bullet = base_bullet_scene.instance()
	grid_dimensions = Vector2(4, 2)
	for i in range(0, grid_dimensions.x * grid_dimensions.y):
		modules.append(null)
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
	if (pos == Vector2(0, 0)):
		root_module = module
	
	build_module_links()
	
	load_bullet()

func build_module_links():
	for i in range(0, modules.size):
		var module = modules[i]
		module.next_modules = []
		if (module.link_north && get_module_y(i) > 0):
			module.next_modules.append(modules[get_module_at(Vector2(get_module_x(i), get_module_y(i) - 1))])
		
		if (module.link_south && get_module_y(i) < grid_dimensions.y - 1):
			module.next_modules.append(modules[get_module_at(Vector2(get_module_x(i), get_module_y(i) + 1))])
		
		if (module.link_east && get_module_x(i) < grid_dimensions.x - 1):
			module.next_modules.append(modules[get_module_at(Vector2(get_module_x(i) + 1, get_module_y(i)))])
		
		if (module.link_west && get_module_x(i) > 0):
			module.next_modules.append(modules[get_module_at(Vector2(get_module_x(i) - 1, get_module_y(i)))])

func fire_bullet():
	for modified_bullet in modified_bullets:
		if (bullet_timers.size() <= modified_bullets.find(modified_bullet) || bullet_timers[modified_bullets.find(modified_bullet)] == 0):
			var new_bullet = modified_bullet.duplicate()
			new_bullet.fire()
			if (bullet_timers.size() <= modified_bullets.find(modified_bullet)):
				bullet_timers.append(modified_bullet.rate_of_fire)
			else:
				bullet_timers[modified_bullets.find(modified_bullet)] = modified_bullet.rate_of_fire

func get_module_x(index):
	return index % grid_dimensions.y

func get_module_y(index):
	return floor(index / grid_dimensions.x)

func get_module_at(vector):
	return modules[vector.y * grid_dimensions.y + vector.x]