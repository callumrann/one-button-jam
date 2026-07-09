extends Node

var levels: = ["res://scenes/levels/level1.tscn","res://scenes/levels/level2.tscn"]
var current_level: int = 1
var level_container: Node2D = null

var level_time: float = 0.0
var level_deaths: int = 0

var show_complete_screen: bool = false # move this logic elsewhere?

func _process(delta: float) -> void:
	level_time += delta

func load_level(level: int) -> void:
	if level_container == null:
		print("Level container not set in level manager")
		return
	# might not need loop, but whatevs
	for child in level_container.get_children():
		child.queue_free()
	var new_level = load(levels[level- 1]).instantiate()
	level_container.add_child(new_level)
	
	current_level = level

func restart_level() -> void:
	level_time = 0
	level_deaths = 0
	load_level(current_level)
	# reset splatters

func load_next_level() -> void:
	current_level += 1
	
	level_time = 0.0
	level_deaths = 0
	
	if current_level <= levels.size():
		load_level(current_level)
		#call_deferred("load_level", current_level) # dont know why needed deferred with queue free, but fixed errors
	else:
		print("finish screen")

func player_died() -> void:
	level_deaths += 1
	load_level(current_level)

func level_finished() -> void:
	print ("endzone reached")
	show_complete_screen = true

func show_message(text: String, duration: float = 3.0) -> void: # use for later dialogue if time
	pass

# make death less hard on eyes (turn screen black + spawn animation or smth)
# add win animation, somehow make player sit still
