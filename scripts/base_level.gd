class_name Level
extends Node2D

func _ready() -> void:
	$Player.endzone_reached.connect(_on_level_complete) # could change player to var, and connection to manual perchance

func _on_level_complete() -> void:
	print("endzone reached")
	LevelManager.level_finished()
