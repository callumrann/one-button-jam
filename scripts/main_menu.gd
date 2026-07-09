extends Control

func _ready() -> void:
	if OS.get_name() == "Web": # test this before due day
		$"VBoxContainer/Quit".visible = false

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
