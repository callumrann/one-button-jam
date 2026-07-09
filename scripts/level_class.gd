class_name Level
extends Node2D

@onready var spawn: Marker2D = $"Spawn"

const PLAYER_SCENE: Resource = preload("res://scenes/objects/player.tscn")
var player: CharacterBody2D

func _ready() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = spawn.global_position
	add_child(player)
	player.kill_player.connect(_on_death)
	player.endzone_reached.connect(_on_level_complete)
	player.get_node("Camera2D").make_current() # stop flicker on restart

func _on_death() -> void:
	LevelManager.player_died()

func _on_level_complete() -> void:
	LevelManager.level_finished()
