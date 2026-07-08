class_name Level # need base level, or just this script?
extends Node2D

@onready var spawn: Marker2D = $"Spawn"

const PLAYER_SCENE: Resource = preload("res://scenes/player.tscn")
var player: CharacterBody2D

func _ready() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = spawn.global_position
	add_child(player)
	player.endzone_reached.connect(_on_level_complete)
	player.kill_player.connect(_on_death)

func _physics_process(delta: float) -> void:
	pass

func _on_death() -> void:
	player.global_position = spawn.global_position
	player.direction = player.RIGHT # some levels may have different directions
	LevelManager.player_died()

func _on_level_complete() -> void:
	LevelManager.level_finished()
