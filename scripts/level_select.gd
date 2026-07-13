extends Control

@onready var stats_label: Label = $"Stats"

func _on_tutorial_pressed() -> void:
	_load_level(1)

func _on_together_pressed() -> void:
	_load_level(2)

func _on_leak_pressed() -> void:
	_load_level(3)

func _on_definitely_pressed() -> void:
	_load_level(4)

func _on_red_rising_pressed() -> void:
	_load_level(5)

func _on_too_much_red_pressed() -> void:
	_load_level(6)

func _load_level(level: int) -> void:
	LevelManager.current_level = level
	SceneManager.show_scene("res://scenes/levels/levels_loader.tscn")


func _on_tutorial_mouse_entered() -> void:
	_show_stats(1)

func _on_together_mouse_entered() -> void:
	_show_stats(2)

func _on_leak_mouse_entered() -> void:
	_show_stats(3)

func _on_definitely_mouse_entered() -> void:
	_show_stats(4)

func _on_red_rising_mouse_entered() -> void:
	_show_stats(5)

func _on_too_much_red_mouse_entered() -> void:
	_show_stats(6)

func _show_stats(level: int) -> void:
	var stats = LevelManager.level_stats.get(level - 1, null)
	if stats == null:
		stats_label.text = "Not Yet Attempted"
		stats_label.visible = true
	else:
		var time_text: String
		if stats["best_time"] == INF:
			time_text = "Best --"
		else:
			time_text = "Best: %.2fs" % stats["best_time"]
		stats_label.text = "%s\nTotal Deaths: %d" % [time_text, stats["total_deaths"]]
		stats_label.visible = true

func _on_mouse_exited() -> void:
	stats_label.visible = false


func _on_main_menu_pressed() -> void:
	SceneManager.show_scene("res://scenes/menus/main_menu.tscn")
