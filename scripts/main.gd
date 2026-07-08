extends Node2D

func _ready() -> void:
	LevelManager.level_container = $"LevelContainer"
	LevelManager.load_level(1)


# Consider HUD giving labels etc control parent
# Select fonts
