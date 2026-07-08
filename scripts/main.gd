extends Node2D

func _ready() -> void:
	LevelManager.level_container = $"LevelContainer"
	LevelManager.load_level(1)
