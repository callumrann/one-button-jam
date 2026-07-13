extends Control


func _on_main_menu_pressed() -> void:
	AudioManager.play_music("menu", -10)
	SceneManager.show_scene("res://scenes/menus/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		AudioManager.play_sfx("click", -10)
		AudioManager.play_music("menu", -10)
		SceneManager.show_scene("res://scenes/menus/main_menu.tscn")
