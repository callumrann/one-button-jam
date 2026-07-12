extends Node

var level_loader: Node2D = null

const THEMES: = [
	["527025", "7aa03f", "1a421c", "defbd8"],
	["ff7831", "f39949", "ca5a2e", "ebc275"]
]

var levels: = ["res://scenes/levels/level1.tscn","res://scenes/levels/level2.tscn"]
var level_themes:= [0, 0]
var current_level: int = 1
var level_container: Node2D = null

var player: CharacterBody2D
var spawn: Marker2D

var level_time: float = 0.0
var level_deaths: int = 0

var show_complete_screen: bool = false # move this logic elsewhere?

func _process(delta: float) -> void:
	level_time += delta

func load_level(level: int) -> void:
	if level_container == null:
		print("Level container not set in level manager")
		return
	call_deferred("_do_load_level", level)
	
	LevelManager.show_complete_screen = false
	level_time = 0
	level_deaths = 0
	

func _do_load_level(level: int) -> void:
	current_level = level
	# might not need loop, but whatevs
	for child in level_container.get_children():
		child.queue_free()
	var new_level = load(levels[level- 1]).instantiate()
	level_container.add_child(new_level)

func load_theme(level: Node2D) -> void:
	var level_theme = THEMES[level_themes[current_level - 1]]
	
	level.get_node("Layers/Background").modulate = Color(level_theme[0])
	level.get_node("Layers/Midground").modulate = Color(level_theme[1])
	level.get_node("Layers/Foreground").modulate = Color(level_theme[2])
	
	level.get_node("Player/AnimatedBody").modulate = Color(level_theme[2])
	level.get_node("Player/AnimatedEyes").modulate = Color(level_theme[3])
	
	level_loader.get_node("BackColour/ColorRect").modulate = Color(level_theme[3])
	
	for object in level.get_node("Enemies/Saws").get_children():
		object.modulate = Color(level_theme[2])
	
	level.get_node("RockSpawner").set_theme(level_theme[1])

func restart_level() -> void:
	load_level(current_level)
	# reset splatters

func load_next_level() -> void:
	current_level += 1
	
	if current_level <= levels.size():
		load_level(current_level)
	else:
		SceneManager.show_scene("res://scenes/menus/game_finished.tscn")

func player_died() -> void:
	level_deaths += 1
	AudioManager.play_sfx("damage")
	
	await _death_flash()
	
	for node in get_tree().get_nodes_in_group("Resettable"):
		node.reset_state()
	
	player.global_position = spawn.global_position
	player.direction = player.RIGHT

func _death_flash() -> void:
	var animatedBody: AnimatedSprite2D = player.get_node("AnimatedBody")
	var animatedEyes: AnimatedSprite2D = player.get_node("AnimatedEyes")
	
	var original_body_colour: Color = animatedBody.modulate
	var original_eyes_colour: Color = animatedEyes.modulate
	
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(animatedBody, "modulate", Color(1, 1, 1, 0), 0.3)
	tween.tween_property(animatedEyes, "modulate", Color(1, 1, 1, 0), 0.3)
	
	player.await_respawn()
	await tween.finished
	player.respawned()
	
	animatedBody.modulate = Color(original_body_colour)
	animatedEyes.modulate = Color(original_eyes_colour)

func level_finished() -> void:
	AudioManager.play_sfx("level_win", -10)
	show_complete_screen = true

func show_message(text: String, duration: float = 3.0) -> void: # use for later dialogue if time
	pass

# make death less hard on eyes (turn screen black + spawn animation or smth)
# add win animation, somehow make player sit still
# consider making space go to next level
# announce if new best time for player
# fans, cannons, raising and falling lava, breaking blocks, springs, moving saws
# ready, set, run at start?
# add practice mode? <- can't be too hard for jam
# test web quit button disappear
# add future buttons to group
