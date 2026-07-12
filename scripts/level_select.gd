extends Control


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
