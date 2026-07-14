extends Control
@onready var music_toggle: CheckBox = $"PanelContainer/VBoxContainer/HBoxContainer/CheckBox"
@onready var sfx_toggle: CheckBox = $"PanelContainer/VBoxContainer/HBoxContainer2/CheckBox"

func _ready() -> void:
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	
	music_toggle.button_pressed = not AudioServer.is_bus_mute(music_bus)
	sfx_toggle.button_pressed = not AudioServer.is_bus_mute(sfx_bus)
	
	music_toggle.toggled.connect(_on_music_toggled)
	sfx_toggle.toggled.connect(_on_sfx_toggled)

func _on_music_toggled(is_on: bool) -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus, not is_on)

func _on_sfx_toggled(is_on: bool) -> void:
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus, not is_on)

func _on_main_menu_pressed() -> void:
	LevelManager.save_stats()
	AudioManager.play_music("menu", -10)
	SceneManager.show_scene("res://scenes/menus/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		AudioManager.play_sfx("click", -10)
		AudioManager.play_music("menu", -10)
		SceneManager.show_scene("res://scenes/menus/main_menu.tscn")
