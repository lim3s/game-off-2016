
# gun script

# member variables
var gun_name

var modules = []
var grid_dimensions = Vector2()

var root_module # module object ref
var tail_module # module object ref
var muzzle_module # muzzle ref

var base_bullet # bullet object ref

func load_bullet():
	var new_bullet = base_bullet.instance()
	root_module.load_bullet(new_bullet)

func fire_bullet(bullet):
	bullet.fire()