extends Node

var level_loader: Node2D = null

const THEMES: = [
	["527025", "7aa03f", "1a421c", "defbd8"],
	["1e579c", "0098db", "223866", "0cb6f2"],
	["ba5044", "d6582f", "8c2d42", "e29883"],
	["ff7831", "f39949", "ca5a2e", "ebc275"], # saves
	["b91b54", "d53c6a", "7c183c", "ff8274"],
	["ba5044", "d6792f", "8f1b45", "ba7844"],
	["ba5044", "d66d2f", "7c183c", "e29883"],
]

var level_stats := {}  
# structure: { level_index: {"best_time": float, "total_deaths": int} }

var levels: = [
	"res://scenes/levels/level1.tscn","res://scenes/levels/level2.tscn",
	"res://scenes/levels/level3.tscn","res://scenes/levels/level4.tscn",
	"res://scenes/levels/level5.tscn","res://scenes/levels/level6.tscn",
	]
var level_themes:= [0, 0, 1, 1, 2, 2]
var current_level: int = 1
var level_container: Node2D = null

var player: CharacterBody2D
var spawn: Marker2D

var level_time: float = 0.0
var new_best_time: bool = false

var show_complete_screen: bool = false # move this logic elsewhere?

func _process(delta: float) -> void:
	if !show_complete_screen: # pause screen auto pauses through tree
		level_time += delta

func load_level(level: int) -> void:
	if level_container == null:
		print("Level container not set in level manager")
		return
	call_deferred("_do_load_level", level)
	
	LevelManager.show_complete_screen = false
	level_time = 0
	

func _do_load_level(level: int) -> void:
	current_level = level
	save_stats()
	
	if current_level > levels.size():
		SceneManager.show_scene("res://scenes/menus/game_finished.tscn")
		return
	
	# might not need loop, but whatevs
	for child in level_container.get_children():
		child.queue_free()
	var new_level = load(levels[level- 1]).instantiate()
	level_container.add_child(new_level)

func load_theme(level: Node2D) -> void:
	var level_theme = THEMES[level_themes[current_level - 1]]
	
	# Tilemap Layers
	level.get_node("Layers/Background").modulate = Color(level_theme[0])
	level.get_node("Layers/Midground").modulate = Color(level_theme[1])
	level.get_node("Layers/Foreground").modulate = Color(level_theme[2])
	
	# Player
	level.get_node("Player/AnimatedBody").modulate = Color(level_theme[2])
	level.get_node("Player/AnimatedEyes").modulate = Color(level_theme[3])
	
	# Background Colour
	level_loader.get_node("BackColour/ColorRect").modulate = Color(level_theme[3])
	
	# Saws
	for object in level.get_node("Enemies/Saws").get_children():
		object.modulate = Color(level_theme[2])
	
	# Falling Tiles
	for object in level.get_node("Enemies/FallingTiles").get_children():
		object.get_node("Fallable/Shake/MainBody").modulate = Color(level_theme[2])
		object.get_node("Fallable/Shake/Cracks").modulate = Color(level_theme[1])
	
	# Buttons and Doors
	for object in level.get_node("Enemies/ButtonsAndDoors").get_children():
		'''
		if "Button" in object.name:
			object.modulate = Color(level_theme[3])
		else:
			object.modulate = Color(level_theme[2])
		'''
		object.modulate = Color(level_theme[2])
	
	# Rock Spawner
	level.get_node("RockSpawner").set_theme(level_theme[1])

func restart_level() -> void:
	load_level(current_level)
	# reset splatters

func load_next_level() -> void:
	current_level += 1
	load_level(current_level)

func player_died() -> void:
	var stats = level_stats.get(current_level - 1, {"best_time": INF, "total_deaths": 0})
	stats["total_deaths"] += 1
	level_stats[current_level - 1] = stats
	save_stats()

	level_time = 0.0
	AudioManager.play_sfx("damage")
	
	await _death_flash()
	
	if player == null: # stop pause main menu will dead bug (bit sus)
		return
	
	player.global_position = spawn.global_position
	player.direction = player.RIGHT
	
	await get_tree().create_timer(0.01).timeout # sus race condition fix
	
	player.respawned()
	
	for node in get_tree().get_nodes_in_group("Resettable"):
		node.reset_state()

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
	if player == null:
		return
	
	if animatedBody == null or animatedEyes == null: # dont know why player == null failing
		return
	animatedBody.modulate = Color(original_body_colour)
	animatedEyes.modulate = Color(original_eyes_colour)

func level_finished() -> void:
	show_complete_screen = true
	AudioManager.play_sfx("level_win", -10)
	
	var stats = level_stats.get(current_level - 1, {"best_time": INF, "total_deaths": 0})
	
	if level_time < stats["best_time"]:
		stats["best_time"] = level_time
		new_best_time = true
	else:
		new_best_time = false
	
	level_stats[current_level - 1] = stats
	save_stats()

'''
===== Saving and Retrieving =====
'''
const SAVE_PATH := "user://save_data.json"

func _ready() -> void:
	load_stats()

func save_stats() -> void:
	var save_data = {
		"level_stats": level_stats,
		"current_level": current_level
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		print("Failed to open save file (write): ", FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify(save_data))
	file.close()

func load_stats() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		print("Failed open save file (read):, ", FileAccess.get_open_error())
		return
	var data = JSON.parse_string(file.get_as_text())
	if data:
		level_stats = {}
		for key in data["level_stats"].keys():
			level_stats[int(key)] = data["level_stats"][key]
		current_level = data.get("current_level", 1)
		file.close()

# consider making space go to next level
# test web quit button disappear
# add future buttons to group
# rename level select buttons etc
# lvl 4 cut off shot first part
# touch up level 4 spikes first part
# check collision with debug for tilemap issues
# level 6, have button right behind start, lava force up
# lava in name of level 5 and put water before hand
# add thanks for playing screen to menu?
# level 6 have fallable blocks, must leave path to get back
# test level 5 lava rise times when more awake
