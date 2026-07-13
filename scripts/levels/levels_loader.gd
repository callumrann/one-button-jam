extends Node2D

# could split into individual files if becomes too large

'''
====== HUD and LevelCompleteMenu ===== 
'''
@onready var level_complete_menu: CanvasLayer = $"LevelCompleteMenu"
@onready var level_complete_timer: Label = $"LevelCompleteMenu/Control/PanelContainer/VBoxContainer/HBoxContainer/Stats"

@onready var timer_label: Label = $"HUD/Control/HBoxContainer/TimeLabel"

func _process(_delta: float) -> void:
	level_complete_menu.visible = LevelManager.show_complete_screen
	
	if !LevelManager.show_complete_screen:
		timer_label.text = "%.2f" % LevelManager.level_time
	else:
		if LevelManager.new_best_time:
			level_complete_timer.modulate = Color(1,1,0)
			level_complete_timer.text = "%.2f" % LevelManager.level_time
		else:
			level_complete_timer.modulate = Color(1,1,1)
			level_complete_timer.text = "%.2f" % LevelManager.level_time

func _on_continue_pressed() -> void:
	LevelManager.load_next_level()

func _on_restart_pressed() -> void:
	LevelManager.restart_level()

'''
====== PauseMenu ===== 
'''
@onready var pause_menu: CanvasLayer = $"PauseMenu"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()

func _toggle_pause():
	if LevelManager.show_complete_screen:
		return
	
	pause_menu.visible = !pause_menu.visible
	get_tree().paused = pause_menu.visible # will need to test extent of .paused
	
	if pause_menu.visible:
		AudioManager.play_sfx("pause_in", -15)
	else:
		AudioManager.play_sfx("pause_out", -15)

func _on_resume_pressed() -> void:
	_toggle_pause()

func _on_explode_pressed() -> void:
	LevelManager.player_died()
	_toggle_pause()

func _on_next_level_pressed() -> void:
	LevelManager.load_next_level()
	_toggle_pause()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	AudioManager.play_music("menu", -10)
	SceneManager.show_scene("res://scenes/menus/main_menu.tscn")
	
'''
====== LevelContainer ===== 
'''
func _ready() -> void:
	LevelManager.level_loader = self
	LevelManager.level_container = $"LevelContainer"
	LevelManager.load_level(LevelManager.current_level)
