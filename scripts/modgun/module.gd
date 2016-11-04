
# module script

# member variables
var module_name = ""

var next_modules = []

func load_bullet(bullet_list, bullet):
	modify_bullet(bullet)
	if (next_modules.size()  > 0):
		# load bullet into the first module if it exists
		next_modules[0].load_bullet(bullet_list, bullet)
		# if module has multiple next modules
		if (next_modules.size() > 1):
			# for the rest of the modules
			for i in range(1, next_modules.size()):
				# duplicate the current bullet, add it to the list and send it to the next module
				var new_bullet = bullet.duplcate()
				bullet_list.append(new_bullet)
				next_modules[i].load_bullet(bullet_list, new_bullet)

func modify_bullet(bullet):
	# Do stuff
	pass