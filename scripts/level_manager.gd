extends Node

var levels: = ["res://scenes/levels/level1.tscn","res://scenes/levels/level2.tscn"]
var current_level: int = 1
var level_container: Node2D = null

var level_timer: float = 0.0

var level_deaths: int = 0

func _physics_process(delta: float) -> void:
	level_timer += delta

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

func player_died() -> void:
	level_deaths += 1

func level_finished() -> void:
	print ("endzone reached")
	current_level += 1
	# save time and deaths
	level_timer = 0.0
	level_deaths = 0
	
	if current_level <= levels.size():
		load_level(current_level) # change to showing menu, which then loads next on player input (space)
		# load deferred?
	else:
		print("finish screen")
	
