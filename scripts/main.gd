extends Node2D

# could split into three files if becomes too large

func _ready() -> void:
	_pause_menu_ready()
	_level_container_ready()

'''
====== HUD ===== 
'''
@onready var timer_label: Label = $"HUD/Control/TimeLabel"
@onready var death_label: Label = $"HUD/Control/DeathsLabel"

func _process(_delta: float) -> void:
	timer_label.text = "Time: %.2f" % LevelManager.level_time
	death_label.text = "Deaths: %d" % LevelManager.level_deaths
'''
====== PauseMenu ===== 
'''
@onready var pause_menu: CanvasLayer = $"PauseMenu"

func _pause_menu_ready() -> void:
	pause_menu.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()

func _toggle_pause():
	pause_menu.visible = !pause_menu.visible
	get_tree().paused = pause_menu.visible # will need to test extent of .paused

func _on_resume_pressed() -> void:
	_toggle_pause()

func _on_restart_pressed() -> void:
	LevelManager.restart_level() # perhaps change later (whole colour splatter idea)
	_toggle_pause()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

'''
====== LevelContainer ===== 
'''
func _level_container_ready() -> void:
	LevelManager.level_container = $"LevelContainer"
	LevelManager.load_level(1)
