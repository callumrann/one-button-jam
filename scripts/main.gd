extends SubViewport

# could split into individual files if becomes too large

'''
====== HUD and LevelCompleteMenu ===== 
'''
@onready var level_complete_menu: CanvasLayer = $"LevelCompleteMenu"

@onready var timer_label: Label = $"HUD/Control/TimeLabel"
@onready var death_label: Label = $"HUD/Control/DeathsLabel"

func _process(_delta: float) -> void:
	level_complete_menu.visible = LevelManager.show_complete_screen
	
	if !LevelManager.show_complete_screen: # stops timers, else remove? - text holds end times
		timer_label.text = "Time: %.2f" % LevelManager.level_time
		death_label.text = "Deaths: %d" % LevelManager.level_deaths

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

func _on_resume_pressed() -> void:
	_toggle_pause()

func _on_explode_pressed() -> void:
	LevelManager.player_died()
	_toggle_pause()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

'''
====== LevelContainer ===== 
'''
func _ready() -> void:
	LevelManager.level_container = $"LevelContainer"
	LevelManager.load_level(LevelManager.current_level)
